# deployer/deployment.py
import logging
from datetime import datetime
from pathlib import Path

import psycopg2

from tool_deployer.models import Config
from tool_deployer.validators import validate_plan_file, validate_sql_script


class Deployment:
    def __init__(self, env, action, version, steps, schema):
        self.env = env
        self.action = action
        self.version = version
        self.steps = steps
        self.schema = schema
        self.config = Config.load_from_env()
        self.config.validate()
        self.logger = logging.getLogger(__name__)

    def run(self):
        if self.action == "deploy":
            self.deploy()
        elif self.action == "drop_schema":
            self.drop_schema()

    def deploy(self):
        plan_path = Path(self.schema) / f"{self.version}_{self.env}.plan.yaml"
        self.logger.info(f"Loading plan file: {plan_path}")
        conn = self._connect_db()
        try:
            plan = validate_plan_file(plan_path)
            scripts = plan.steps
            scripts_to_run = plan.get_scripts_to_run(scripts, self.steps)
            self.logger.info(f"Steps to deploy: {len(scripts_to_run)}")
            self.logger.debug(f"Steps to deploy: {scripts_to_run}")
            for script in scripts_to_run:
                sql_script = validate_sql_script(Path(self.schema) / f"{script.source}.sql")
                self.logger.debug(f"Script to deploy: {sql_script}")
                self.apply_sql_file(conn, sql_script.script)
                script.deployed = datetime.now().astimezone().isoformat()
                self.logger.info(
                    f"Deployed step: {script.source} by {script.author} on {script.date}: {script.description}"
                )
            plan.update(plan_path)
            conn.commit()
            self.logger.info(f"Successfully deployed the plan: {self.version}_{self.env}.plan.yaml")
        except Exception as e:
            self.logger.error(f"Failed to deploy schema: {e}")
            conn.rollback()
        finally:
            conn.close()
            self.logger.debug("Database connection closed")

    def drop_schema(self):
        conn = self._connect_db()
        try:
            with conn.cursor() as cur:
                cur.execute(f"DROP SCHEMA {self.schema} CASCADE")
                self.logger.info(f"Dropped schema: {self.schema}")
            conn.commit()
        except Exception as e:
            self.logger.error(f"An error occurred while dropping schema: {e}")
            conn.rollback()
        finally:
            conn.close()
            self.logger.info("Database connection closed")

    def _connect_db(self):
        self.logger.info("Connecting to the database")
        try:
            return psycopg2.connect(
                host=self.config.db_host,
                port=self.config.db_port,
                dbname=self.config.db_name,
                user=self.config.db_user,
                password=self.config.db_password,
            )
        except Exception as e:
            self.logger.error(f"Failed to connect to the database: {e}")
            raise

    @staticmethod
    def apply_sql_file(conn, script):
        with conn.cursor() as cur:
            cur.execute(script)

# deployer/deployment.py
import logging
from datetime import datetime
from pathlib import Path

import psycopg2
import yaml

from tool_deployer.models import Config
from tool_deployer.validators import validate_plan_file, validate_sql_script


class DatabaseConnection:
    def __init__(self, config):
        self.config = config
        self.logger = logging.getLogger(__name__)
        self.conn = None

    def __enter__(self):
        self.logger.info(f"Connecting to the database: {self.config}")
        try:
            self.conn = psycopg2.connect(
                host=self.config.db_host,
                port=self.config.db_port,
                dbname=self.config.db_name,
                user=self.config.db_user,
                password=self.config.db_password,
            )
            return self.conn
        except Exception as e:
            self.logger.error(f"Failed to connect to the database: {e}")
            raise

    def __exit__(self, exc_type, exc_value, traceback):
        if self.conn:
            self.conn.close()
            self.logger.debug("Database connection closed")


class DeployPlan:
    def __init__(self, version, kind, schema, env, steps):
        self.version = version
        self.kind = kind
        self.schema = schema
        self.env = env
        self.steps = steps

    @staticmethod
    def load(plan_path):
        with open(plan_path, "r") as file:
            data = yaml.safe_load(file)
        return DeployPlan(**data)

    def get_scripts_to_run(self, specified_steps):
        return [step for step in self.steps if step.get("deployed") is None and step in specified_steps]

    def update(self, plan_path):
        with open(plan_path, "w") as file:
            yaml.safe_dump(self.__dict__, file, sort_keys=False)


class SQLScript:
    def __init__(self, path):
        self.path = path
        self.script = self._load_script()

    def _load_script(self):
        with open(self.path, "r") as file:
            return file.read()

    @staticmethod
    def validate(script_path):
        if not Path(script_path).exists():
            raise FileNotFoundError(f"SQL script not found: {script_path}")
        return SQLScript(script_path)


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

    def build_plan_path(self):
        if "/" in self.env:
            env_parts = self.env.split("/")
            return Path(self.schema) / f"{self.version}_{env_parts[0]}_{env_parts[1]}.plan.yaml"
        else:
            return Path(self.schema) / f"{self.version}_{self.env}.plan.yaml"

    def build_sql_script_path(self, script_source):
        return Path(self.schema) / f"{script_source}.sql"

    def deploy(self):
        plan_path = self.build_plan_path()
        self.logger.info(f"Loading plan file: {plan_path}")
        plan = DeployPlan.load(plan_path)

        with DatabaseConnection(self.config) as conn:
            try:
                scripts_to_run = plan.get_scripts_to_run(plan.steps)
                self.logger.info(f"Steps to deploy: {len(scripts_to_run)}")
                self.logger.debug(f"Steps to deploy: {scripts_to_run}")

                for script in scripts_to_run:
                    sql_script = SQLScript.validate(self.build_sql_script_path(script["source"]))
                    self.logger.debug(f"Script to deploy: {sql_script.path}")
                    self.apply_sql_file(conn, sql_script.script)
                    script["deployed"] = datetime.now().astimezone().isoformat()
                    self.logger.info(
                        f"Deployed step: {script['source']} by {script['author']} on {script['date']}: {script['description']}"
                    )
                    plan.update(plan_path)

                conn.commit()
                self.logger.info(f"Successfully deployed the plan: {self.version}_{self.env}.plan.yaml")
            except Exception as e:
                self.logger.error(f"Failed to deploy schema: {e}")
                conn.rollback()

    def drop_schema(self):
        with DatabaseConnection(self.config) as conn:
            try:
                with conn.cursor() as cur:
                    cur.execute(f"DROP SCHEMA {self.schema} CASCADE")
                    self.logger.info(f"Dropped schema: {self.schema}")
                conn.commit()
            except Exception as e:
                self.logger.error(f"An error occurred while dropping schema: {e}")
                conn.rollback()

    @staticmethod
    def apply_sql_file(conn, script):
        with conn.cursor() as cur:
            cur.execute(script)

import argparse
from datetime import datetime
from pathlib import Path

import psycopg2
import yaml


def load_config(env):
    """Load environment-specific configuration from YAML."""
    with open(env / "config.yaml") as f:
        return yaml.safe_load(f)


def read_plan(plan_file):
    """Read the plan file and return the plan."""
    with open(plan_file, "r") as file:
        plan = yaml.safe_load(file)
    if plan["version"] != plan_file.name.split("_")[0]:
        raise ValueError("The version of the file is incorrect")
    return plan


def apply_sql_file(conn, filepath):
    """Execute the SQL script from the given file path."""
    with open(filepath, "r") as file:
        sql = file.read()

    with conn.cursor() as cur:
        cur.execute(sql)


def drop_schema(conn, schema_name):
    """Drop a schema and all its objects."""
    with conn.cursor() as cur:
        cur.execute(f"DROP SCHEMA {schema_name} CASCADE")


def filter_scripts_by_steps(scripts, steps):
    """Filter the scripts to be executed based on the specified steps."""
    num_scripts = len(scripts)

    def validate_step_range(start, end):
        if start < 1 or end > num_scripts:
            raise ValueError(f"Step range {start}-{end} is out of bounds. Total steps: {num_scripts}")

    if steps == "all":
        scripts_to_run = [script for script in scripts if script["deployed"] is None]
        if not scripts_to_run:
            raise Exception("All steps have already been deployed.")
        return scripts_to_run
    elif "-" in steps:
        start, end = map(int, steps.split("-"))
        validate_step_range(start, end)
        selected_scripts = scripts[start - 1 : end]
        for script in selected_scripts:
            if script["deployed"] is not None:
                raise Exception(f"Step {script['source']} has already been deployed on {script['deployed']}")
        return selected_scripts
    else:
        step = int(steps)
        if step < 1 or step > num_scripts:
            raise ValueError(f"Step {step} is out of bounds. Total steps: {num_scripts}")
        script = scripts[step - 1]
        if script["deployed"] is not None:
            raise Exception(f"Step {script['source']} has already been deployed on {script['deployed']}")
        return [script]


def update_plan_file(plan_file, plan):
    """Update the plan file with the deployment timestamps."""
    # with open(plan_file, "r") as file:
    #     plan = yaml.safe_load(file)

    # for script in scripts:
    #     for item in plan["metadata"]:
    #         if item["source"] == script["source"]:
    #             item["deployed"] = script["deployed"]

    with open(plan_file, "w") as file:
        yaml.safe_dump(plan, file, sort_keys=False)


def main():
    cwd = Path(__file__).parent

    parser = argparse.ArgumentParser(description="Database Deployment Script")
    parser.add_argument("--env", "-e", required=True, help="The environment to deploy to (e.g., dev, prod)")
    parser.add_argument(
        "--action",
        "-a",
        required=True,
        choices=["deploy", "drop_schema"],
        help="Action to perform (deploy or drop_schema)",
    )
    parser.add_argument("--version", "-v", required=True, help="Version of the plan to deploy (e.g., v0.0.1)")
    parser.add_argument("--steps", "-st", required=True, help="Steps to deploy (e.g., all, 2, 3-4)")
    parser.add_argument(
        "--schema", "-sch", required=True, help="Name of the schema to deploy/drop (required to deploy/drop_schema)"
    )

    args = parser.parse_args()

    config = load_config(cwd / args.schema / args.env)
    plan_file = cwd / args.schema / f"{args.version}_{args.env}.plan.yaml"

    db_config = config["database"]
    conn = psycopg2.connect(
        host=db_config["host"],
        port=db_config["port"],
        dbname=db_config["dbname"],
        user=db_config["user"],
        password=db_config["password"],
    )

    try:
        if args.action == "deploy":
            plan = read_plan(plan_file)

            scripts = plan["steps"]
            scripts_to_run = filter_scripts_by_steps(scripts, args.steps)

            for script in scripts_to_run:
                if args.version != script["source"].split("/")[1]:
                    raise ValueError(
                        f"The schema '{args.schema}' does not match the schema in the source '{script['source']}'"
                    )
                source_path = cwd / args.schema / f"{script['source']}.sql"
                print(
                    f"Applying: {script['source']} by {script['author']} on {script['date']}: {script['description']}"
                )
                apply_sql_file(conn, source_path)
                script["deployed"] = datetime.now().astimezone().isoformat()
            update_plan_file(plan_file, plan)
            conn.commit()
        elif args.action == "drop_schema" and args.schema_name:
            print(f"Dropping schema {args.schema_name}")
            drop_schema(conn, args.schema_name)
            conn.commit()
        else:
            print("Unknown action or missing schema name.")
            conn.rollback()
        print(f"Action {args.action} completed successfully for environment {args.env}.")
    except Exception as e:
        print(f"An error occurred: {e}")
        conn.rollback()
    finally:
        conn.close()


if __name__ == "__main__":
    main()

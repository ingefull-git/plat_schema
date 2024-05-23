# src/tool_deployer/cli.py
import argparse
import logging

from tool_deployer.deployment import Deployment


def main():

    parser = argparse.ArgumentParser(description="Database Deployment Tool")
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
    parser.add_argument(
        "--log-level", "-l", default="INFO", help="Set the logging level (e.g., DEBUG, INFO, WARNING, ERROR, CRITICAL)"
    )

    args = parser.parse_args()

    logging.basicConfig(level=args.log_level.upper(), format="%(asctime)s - %(levelname)s - %(message)s")
    logger = logging.getLogger(__name__)

    logger.info("Starting deployment tool")
    logger.info(
        f"Environment: {args.env}, Action: {args.action}, Version: {args.version}, Steps: {args.steps}, Schema: {args.schema}"
    )

    deployment = Deployment(args.env, args.action, args.version, args.steps, args.schema)
    deployment.run()


if __name__ == "__main__":
    main()

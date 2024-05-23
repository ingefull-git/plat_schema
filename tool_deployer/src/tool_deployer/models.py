# deployer/plan.py
import os
from dataclasses import asdict, dataclass, field
from typing import List, Optional

import yaml


@dataclass
class Step:
    source: str
    author: str
    date: str
    description: str
    deployed: Optional[str] = None


@dataclass
class Plan:
    version: str
    kind: str
    schema: str
    env: str
    steps: List[Step]

    @staticmethod
    def load(plan_file):
        with open(plan_file, "r") as file:
            data = yaml.safe_load(file)

        # Validate and convert steps to Step objects
        steps = [Step(**step) for step in data.get("steps", [])]

        return Plan(version=data["version"], kind=data["kind"], schema=data["schema"], env=data["env"], steps=steps)

    def validate_step_range(self, num_scripts, start, end):
        if start < 1 or end > num_scripts:
            raise ValueError(f"Step range {start}-{end} is out of bounds. Total steps: {num_scripts}")

    def get_scripts_to_run(self, scripts, steps):
        num_scripts = len(scripts)
        if steps == "all":
            scripts_to_run = [script for script in scripts if script.deployed is None]
            if not scripts_to_run:
                raise Exception("All steps have already been deployed.")
            return scripts_to_run
        elif "-" in steps:
            start, end = map(int, steps.split("-"))
            self.validate_step_range(num_scripts, start, end)
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

    def update(self, plan_file):
        with open(plan_file, "w") as file:
            yaml.safe_dump(asdict(self), file, sort_keys=False, default_flow_style=False)


@dataclass
class SQLScript:
    kind: str
    schema: str
    version: str
    script: str  # Holds the actual SQL script content

    @staticmethod
    def load(sql_file):
        with open(sql_file, "r") as file:
            lines = file.readlines()

        metadata = {}
        script_lines = []
        for line in lines:
            if line.startswith("--"):
                key, value = line[2:].strip().split(": ")
                metadata[key] = value
            else:
                script_lines.append(line)

        return SQLScript(
            kind=metadata["kind"], schema=metadata["schema"], version=metadata["version"], script="".join(script_lines)
        )


@dataclass
class Config:
    db_host: str
    db_port: int
    db_name: str
    db_user: str
    db_password: str

    @staticmethod
    def load_from_env():
        return Config(
            db_host=os.getenv("DB_HOST"),
            db_port=os.getenv("DB_PORT"),
            db_name=os.getenv("DB_NAME"),
            db_user=os.getenv("DB_USER"),
            db_password=os.getenv("DB_PASSWORD"),
        )

    def validate(self):
        missing_fields = [field_name for field_name, value in self.__dict__.items() if value is None]
        if missing_fields:
            raise ValueError(f"Missing required config values: {', '.join(missing_fields)}")

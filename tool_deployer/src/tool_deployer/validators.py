from tool_deployer.models import Plan, SQLScript


def validate_plan_file(plan_file):
    try:
        return Plan.load(plan_file)
    except Exception as e:
        raise ValueError(f"Invalid plan file: {e}")


def validate_sql_script(sql_file):
    try:
        return SQLScript.load(sql_file)
    except Exception as e:
        raise ValueError(f"Invalid SQL script: {e}")

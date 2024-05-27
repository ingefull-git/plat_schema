#!/bin/bash
# Usage: ./snapshot_schema.sh schema_name output_file
SCHEMA_NAME=$1
OUTPUT_FILE=$2

# Ensure environment variables are set
if [ -z "$DB_HOST" ] || [ -z "$DB_USER" ] || [ -z "$DB_NAME" ] || [ -z "$DB_PORT" ]; then
  echo "One or more required environment variables are not set: DB_HOST, DB_USER, DB_NAME, DB_PORT"
  exit 1
fi

export PGPASSWORD=$DB_PASSWORD


# Check if the schema exists
SCHEMA_EXISTS=$(psql -h $DB_HOST -U $DB_USER -d $DB_NAME -p $DB_PORT -tc "SELECT 1 FROM information_schema.schemata WHERE schema_name = '$SCHEMA_NAME';" | tr -d '[:space:]')

if [ "$SCHEMA_EXISTS" != "1" ]; then
  echo "Schema $SCHEMA_NAME does not exist"
  exit 0
fi

# Take a snapshot of the schema and save to output file
pg_dump --schema-only --no-owner --no-acl -h $DB_HOST -U $DB_USER -d $DB_NAME -p $DB_PORT -n $SCHEMA_NAME > $OUTPUT_FILE

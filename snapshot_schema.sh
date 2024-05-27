#!/bin/bash
# Usage: ./snapshot_schema.sh schema_name output_file
SCHEMA_NAME=$1
OUTPUT_FILE=$2

# Take a snapshot of the schema and save to output file
pg_dump --schema-only --no-owner --no-acl -h $DB_HOST -U $DB_USER -d $DB_NAME -n $SCHEMA_NAME > $OUTPUT_FILE

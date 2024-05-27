#!/bin/bash
# Usage: ./compare_schemas.sh new_snapshot previous_snapshot
NEW_SNAPSHOT=$1
PREVIOUS_SNAPSHOT=$2

# Compare the two schema files
if diff $NEW_SNAPSHOT $PREVIOUS_SNAPSHOT > /dev/null; then
  echo "Schemas are identical"
  exit 0
else
  echo "Schemas are different"
  exit 1
fi

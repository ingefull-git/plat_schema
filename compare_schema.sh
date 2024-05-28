#!/bin/bash
# Usage: ./compare_schemas.sh new_snapshot previous_snapshot
NEW_SNAPSHOT=$1
PREVIOUS_SNAPSHOT=$2
DIFF_OUTPUT=$3

# Check if the new snapshot file exists
if [ ! -f "$NEW_SNAPSHOT" ]; then
  echo "New snapshot file $NEW_SNAPSHOT does not exist."
  exit 1
fi

# Check if the previous snapshot file exists
if [ ! -f "$PREVIOUS_SNAPSHOT" ]; then
  echo "Previous snapshot file $PREVIOUS_SNAPSHOT does not exist."
  exit 1
fi

# Compare the two schema files
if diff "$NEW_SNAPSHOT" "$PREVIOUS_SNAPSHOT" > /dev/null; then
  echo "Schemas are identical"
  exit 0
else
  echo "Schemas are different, generating diff file."
  diff -u "$PREVIOUS_SNAPSHOT" "$NEW_SNAPSHOT" > "$DIFF_OUTPUT"
  exit 1
fi

#!/bin/bash
# Usage: ./compare_schemas.sh new_snapshot previous_snapshot
NEW_SNAPSHOT=$1
PREVIOUS_SNAPSHOT=$2

echo "Current dir: $(pwd)"
ls


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

# Output the first 10 lines of the new snapshot file for debugging
echo "First 10 lines of $NEW_SNAPSHOT:"
head -n 10 "$NEW_SNAPSHOT"

# Output the first 10 lines of the previous snapshot file for debugging
echo "First 10 lines of $PREVIOUS_SNAPSHOT:"
head -n 10 "$PREVIOUS_SNAPSHOT"

# Compare the two schema files
if diff "$NEW_SNAPSHOT" "$PREVIOUS_SNAPSHOT" > /dev/null; then
  echo "Schemas are identical"
  exit 0
else
  echo "Schemas are different"
  exit 1
fi

#!/bin/bash
# Usage: ./replace_backup.sh new_snapshot previous_snapshot
NEW_SNAPSHOT=$1
PREVIOUS_SNAPSHOT=$2

# Replace the previous snapshot with the new one
cp $NEW_SNAPSHOT $PREVIOUS_SNAPSHOT

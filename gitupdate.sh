#!/bin/bash

set -e

# Check HA configuration
ha core check

# Get number of files added to the index (but uncommitted)
FILES_STAGED=$(git status --porcelain 2>/dev/null| egrep "^A|^M" | wc -l)

if [ $FILES_STAGED -eq 0 ]; then
  echo "Adding all modified files to staging area"
  git add .
fi

git status

echo -n "Change description [minor update]: "
read CHANGE_MSG
CHANGE_MSG=${CHANGE_MSG:-"minor update"}

git commit -m "${CHANGE_MSG}"
git push github main
exit

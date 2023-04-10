#!/bin/bash
###
### Removes coverage report files with names containing the given string from given directory.
###

if [ "$#" -ne 2 ]; then
  echo "You must supply a coverage directory path, then a substring to search for and delete! ie. <path> <substring>"
  exit 1
fi

COV_PATH=$1
SEARCH_STRING=$2

COV_FILES=`find $COV_PATH -name "*$SEARCH_STRING*.lst"`

for val in $COV_FILES; do
  rm $val
done

echo "Removed all .dub-packages- coverage files!"
exit 0
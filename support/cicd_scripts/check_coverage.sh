#!/bin/bash
###
###
###

# Look for .d files and store temporary state in the given file:
SEARCH_FOLDER=$1
COV_DIR="coverage"
COV_PATH=$SEARCH_FOLDER/$COV_DIR

# Find all .d files:
COV_FILES=`find $COV_PATH -name '*.lst'`
echo Code coverage report:

ANY_UNDER_TARGET=false
for val in $COV_FILES; do
  LAST_LINE=$(tail -1 $val)
  LAST_CHARS=$(tail -c 13 $val)
  echo $LAST_LINE
  if [[ "$LAST_CHARS" != " has no code" ]] && [[ "$LAST_CHARS" != "100% covered" ]];
  then
    ANY_UNDER_TARGET=true
  fi
done

# End with error if there were any files under the coverage limit:
if $ANY_UNDER_TARGET;
then
  echo Failed! Not all covered!
  exit 1
fi

# There were no differences! Success!
echo Success! All covered!
exit 0
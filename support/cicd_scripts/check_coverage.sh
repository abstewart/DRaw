#!/bin/bash
###
### Go through each coverage file and verify that every file is 100% covered
### (or contains no code), otherwise, error.
###

# Coverage target:
COVERAGE_TARGET="20"

# Look for .d files and store temporary state in the given file:
SEARCH_FOLDER=$1
COV_DIR="coverage"
COV_PATH=$SEARCH_FOLDER/$COV_DIR

# Find all .d files:
COV_FILES=`find $COV_PATH/* -name '*.lst'`
echo Code coverage report:

# Ensure that the /coverage directory is not empty:
if [ -z "$(ls -A $COV_PATH)" ];
then
  echo Failed! No coverage whatsoever!
  exit 1
fi

ANY_UNDER_TARGET=false
ANY_EMPTY=false
for val in $COV_FILES; do
  LAST_LINE=$(tail -1 $val)
  LAST_CHARS=$(tail -c 13 $val)

  if [ "$LAST_CHARS" = "" ]; then
    ANY_EMPTY=true
    echo "Empty file! $val"
  fi

  if [ $ANY_EMPTY ] && [ "$LAST_CHARS" != " has no code" ] && [ "$LAST_CHARS" != "100% covered" ];
  then
    if [ "$LAST_CHARS" = "s 0% covered" ];
    then
      echo "0%: $val"
      ANY_UNDER_TARGET=true
    else
      if [ "$(echo $LAST_CHARS | tr -d '%' | head -c 2)" -lt $COVERAGE_TARGET ]; then
        echo "below $COVERAGE_TARGET: $val"
        ANY_UNDER_TARGET=true
      fi
    fi
  fi
done

if $ANY_EMPTY; then
  echo "Failed! Delete empty .d files, they generate empty coverage reports which are annoying to deal with!"
  exit 1
fi

# End with error if there were any files under the coverage limit:
if $ANY_UNDER_TARGET;
then
  echo Failed! Not all covered!
  exit 1
fi

# There were no differences! Success!
echo Success! All covered!
exit 0
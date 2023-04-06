#!/bin/bash
###
### Go through each coverage file and verify that every file is 100% covered
### (or contains no code), otherwise, error. (Some of these syntax are courtesy of stack overflow + chatGPT)
###

# Coverage target:
COVERAGE_TARGET=0

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
  LAST_LINE=$(tail -n1 $val)

  if [ "$LAST_LINE" = "" ]; then
    ANY_EMPTY=true
    echo "Empty file! $val"
    continue
  fi

  if echo $LAST_LINE | grep -q "has no code" ; then
    continue
  fi

  COVERAGE_NUMBER=$(echo $LAST_LINE | grep -Eo '*[0-9]{1,3}%*' | rev | cut -c2- | rev)
  if [ $COVERAGE_NUMBER -lt $COVERAGE_TARGET ]; then
    echo "Below $COVERAGE_TARGET% target: $val"
    ANY_UNDER_TARGET=true
  fi
done

if $ANY_EMPTY; then
  echo "NOTE: Empty .lst files were found! Empty .d files create empty .lst files!"
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
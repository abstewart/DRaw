#!/bin/bash
###
### Uses dfmt --inplace to modify all files in the given directory
### to have proper formatting.
###

SEARCH_FOLDER=$1
DSCANNER_CONFIG_PATH=./support/dscanner.ini

if [ $# -eq 2 ]
then
  DSCANNER_CONFIG_PATH=$2
fi

# Find all .d files in the given directory:
DFILES=`find $SEARCH_FOLDER -name '*.d'`

# Format each file:
for val in $DFILES; do
  dub run dscanner -y --verror -- -styleCheck $val --config $DSCANNER_CONFIG_PATH
  dub run dscanner -y --verror -- -syntaxCheck $val --config $DSCANNER_CONFIG_PATH
done


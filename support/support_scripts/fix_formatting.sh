#!/bin/bash
###
### Uses dfmt --inplace to modify all files in the given directory
### to have proper formatting.
###

SEARCH_FOLDER=$1

# Find all .d files in the given directory:
DFILES=`find $SEARCH_FOLDER -name '*.d'`

# Format each file:
for val in $DFILES; do
  dub run dfmt -- -i $val
done


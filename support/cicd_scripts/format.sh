#!/bin/bash


# Find all .d files
DFILES=`find ./ -name '*.d'`


for val in $DFILES; do
  echo $val
done

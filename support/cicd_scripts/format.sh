#!/bin/bash
###
### Uses the dfmt library to check if all .d files in the given directory are
### properly formatted. If they are - succeed, if not - fail.
###

# Look for .d files and store temporary state in the given file:
SEARCH_FOLDER=$1
D_COPY_DIR="d_file_copies"
D_COPY_PATH=$SEARCH_FOLDER/$D_COPY_DIR

# If a previously-made copy folder exists, wipe it:
if [ -d $D_COPY_PATH ];
then
  rm -r $D_COPY_PATH
fi

# Make a new copy folder to run dfmt inside:
mkdir $D_COPY_PATH

# Find all .d files:
DFILES=`find $SEARCH_FOLDER -name '*.d'`


# Copy all files over:
for val in $DFILES; do
  cp $val $D_COPY_PATH/$(basename $val)
done

# Run the formatter on the copied files:
dub fetch dfmt
for val in $DFILES; do
  dub run dfmt -- -i $D_COPY_PATH/$(basename $val)
done

# Record if any of the files are different so we can fail later:
ANY_DIFFERENT=False
for val in $DFILES; do
  COPIED_PATH=$D_COPY_PATH/$(basename $val)
  cmp -s $val $COPIED_PATH || echo `cmp $val $COPIED_PATH` || ANY_DIFFERENT=True
done

# Wipe the copy file:
if [ -d $D_COPY_PATH ];
then
  rm -r $D_COPY_PATH
fi

# End with error if there were any differences:
if [ $ANY_DIFFERENT ];
then
  exit 1
fi

# There were no differences! Success!
exit
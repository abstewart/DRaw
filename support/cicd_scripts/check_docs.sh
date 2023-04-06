#!/bin/bash
###
### Checks that the current /docs folder is up to date. Must be run from the root of the dub project in question.
###

# Look for .d files and store temporary state in the given file:
SEARCH_FOLDER=$(pwd)
DOC_COPY_DIR="doc_copies"
ORIGINAL_DOC_PATH=$SEARCH_FOLDER/docs
DOC_COPY_PATH=$SEARCH_FOLDER/$DOC_COPY_DIR

#mv $ORIGINAL_DOC_PATH $DOC_COPY_PATH


if [ -d $DOC_COPY_PATH ];
then
  rm -r $DOC_COPY_PATH
fi

mkdir $DOC_COPY_PATH

DOC_FILES=`find $ORIGINAL_DOC_PATH -name '*.html'`

# Copy all files over:
for val in $DOC_FILES; do
  cp $val $DOC_COPY_PATH/$(basename $val)
done


dub --build=docs


# Record if any of the files are different so we can fail later:
ANY_DIFFERENT=false
for val in $DOC_FILES; do
  COPY_PATH=$DOC_COPY_PATH/$(basename $val)
  if ! cmp -s $val $COPY_PATH; then
    cmp $val $COPY_PATH
    ANY_DIFFERENT=true
  fi
done

# Wipe the copy file:
if [ -d $ORIGINAL_DOC_PATH ];
then
  rm -r $ORIGINAL_DOC_PATH
fi



mkdir $ORIGINAL_DOC_PATH

COPIED_DOC_FILES=`find $DOC_COPY_PATH -name '*.html'`

# Copy all files over:
for val in $COPIED_DOC_FILES; do
  cp $val $ORIGINAL_DOC_PATH/$(basename $val)
done
rm -r $DOC_COPY_PATH

#mv $DOC_COPY_PATH $ORIGINAL_DOC_PATH




# End with error if there were any differences:
if $ANY_DIFFERENT;
then
  echo Failed! Regenerate the docs and try again!!
  exit 1
fi

# There were no differences! Success!
echo Success! All docs up to date!!
exit 0
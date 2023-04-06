#!/bin/bash
###
### Checks that the current /docs folder is up to date. Must be run from the root of the dub project in question.
###

# Look for .d files and store temporary state in the given file:
SEARCH_FOLDER=$1
DOC_COPY_DIR="doc_copies"
ORIGINAL_DOC_PATH=$SEARCH_FOLDER/docs
DOC_COPY_PATH=$SEARCH_FOLDER/$DOC_COPY_DIR

mv $ORIGINAL_DOC_PATH $DOC_COPY_PATH

dub --build=docs

DOC_FILES=`find $ORIGINAL_DOC_PATH -name '*.html'`

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

mv $DOC_COPY_PATH $ORIGINAL_DOC_PATH

# End with error if there were any differences:
if $ANY_DIFFERENT;
then
  echo Failed! Regenerate the docs and try again!!
  exit 1
fi

# There were no differences! Success!
echo Success! All docs up to date!!
exit 0
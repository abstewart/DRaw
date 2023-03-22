#!/bin/bash
###
### Generates docs with Ddoc. The reason this is in a script despite being
### so small is because '/*.d' syntax doesn't work on all shells (namely windows).
###

# Document the .d files from and output to the given directory:
D_SOURCE_FOLDER=$1

# Generate the documentation:
dmd -D -Dd=$D_SOURCE_FOLDER/docs -od="$D_SOURCE_FOLDER\bin" -of="$D_SOURCE_FOLDER\bin\prog" $D_SOURCE_FOLDER/source/*.d
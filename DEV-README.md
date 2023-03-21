

# Developer's guide: How to use the DRaw CI/CD

## 1) To run unit tests:
If you are on Mac, run `dub run test`. If you are on windows, the OS/dub will get upset with the format of the path build paths (ie "bin/ut.d" instead of "bin/ut.d"), so run `dub run --build=unittest` (somehow the unix style paths do not upset windows when you run with this command... confusing).

## 2) Code coverage:
### a) To generate code coverage:
Run `dub -b cov`. The coverage files will then be generated in `./coverage`.

### b) To check code coverage (100% or not?):
Ensure coverage `.lst` files have been generated and are in `.../coverage` Then, run `sh ./support/cicd_scripts/check_coverage.sh <dub_project_root_directory_to_check_coverage_for>`.

## 3) To generate docs:
Run `sh ./support/cicd_scripts/generate_docs.sh <dub_project_root_directory_to_generate_docs_for>`. If you are not on windows, in theory, you can also run `dmd -D -Dd=docs -od=./bin -of=./bin/prog ./source/*.d` in the directory you want to generate docs for (the `/*.d` syntax does not work in cmd/powershell).

## 4) Code formatting:
### a) Check code formatting:
Run `sh ./support/cicd_scripts/format.sh <dub_project_root_directory_to_check_formatting_for>`. 

### b) Automatically fix code formatting:
If there are files which aren't properly formatted, run `dub run dfmt -- -i <path_of_file_to_format.d>` to reformat it in place. NOTE: The [dfmt docs](https://code.dlang.org/packages/dfmt#:~:text=Make%20backups%20of%20your%20files) say to make sure you have an easy way to revert changes if you format in-place (which is what this command does). If your IDE git integration doesn't let you easily revert changes, perhaps make a copy of the files.
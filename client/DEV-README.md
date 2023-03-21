

# Developer's guide: How to use the DRaw CI/CD

## 1) To run unit tests:

- If you are on Mac, run `dub run test`. If you are on windows, the OS/dub will get upset with the format of the path build paths (ie "bin/ut.d" instead of "bin/ut.d"), so run `dub run --build=unittest` (somehow the unix style paths do not upset windows when you run with this command... confusing).

## 2) To run code coverage:
- Run `dub -b cov`. The coverage files will then be generated in `./coverage`.

## 3) To Generate coverage:
- Run `dub -b cov` in the directory you want to generate coverage for.

## 4) To Generate docs:
- Run `sh ./support/cicd_scripts/generate_docs.sh <dub_project_root_directory_to_generate_docs_for>`. If you are not on windows, in theory, you can also run `dmd -D -Dd=docs -od=./bin -of=./bin/prog ./source/*.d` in the directory you want to generate docs for (the `/*.d` syntax does not work in cmd/powershell).
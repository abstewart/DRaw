

# Part 1 - Developer's guide: How to use the DRaw CI/CD

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


# Part 2 - Guidelines for Opening and Merging a Pull Request:

Note: We can change this procedure however we like, but this is an initial suggestion.

1. Ensure you are working on a separate "feature branch" which has been linked to a GitHub issue so we know what code is correlated with which features/when and who. For an example of a linked branch/how to link one, check out the "Development" menu at the bottom right of [this issue](https://github.com/Spring23FSE/finalproject-draw/issues/1). It should show the "1-set-up-a-cicd-system-via-github-actions" branch is linked.
2. Make sure the CI/CD is passing, otherwise you will not be able to merge. Passing requirements are as follows:
   - All `.d` files are formatted to [dfmt's specifications](https://code.dlang.org/packages/dfmt).
   - Test coverage is 100%
   - All unit tests pass
3. ??? Clean up your git commit history ??? (this might be more effort than it's worth + not sure the professor/TAs care as long as the commit messages are semi-reasonable)
4. Open a pull request for the issue.
   - Add one of us as a primary reviewer and another as a secondary reviewer. The Pull Request should not be merged until the primary reviewer has approved it.
   - Notify everyone via Teams that a PR needs approval.
5. Address any feedback the reviewers have given.
6. Once all feedback is addressed and the Pull Request has been approved by the primary, hit merge!!!


# Part 3 - General Notes About Project Structure
Our project is currently split into two dub projects; one for the client application and one for the server. This definitely lead to a bit of redundancy, so we can change this if we think it is more redundant than it is helpful.

In each dub project source directory there are the following files with the following purposes:

- `app.d` - The app.d we all know and love. Expand from here!
- `move_coverage_files.d` - This file is very important. It ensures coverage files are generated in `./coverage` and not just littering the root directory of the dub project. No need to move, add to, or delete this file until we can find a more elegant solution.
- `test_example_1.d` - Just an example unit test to test unit-threaded. Can be deleted as we add more.
- `test_example_2.d` - Same as above.

All source files -as well as test files- should go in `./source`. Test files should be named with the convention `test_<whatever_name_you_want>.d`, so that unit-threaded + other testing tools can find them.

At the moment, 100% test coverage is required for CI/CD to pass. We can lower this if we like, but I think 100% is a good -and reasonable- initial target.


# Developer's guide: How to use the DRaw CI/CD

## 1) To run unit tests:

- If you are on Mac, run `dub run test`. If you are on windows, the OS/dub will get upset with the format of the path build paths (ie "bin/ut.d" instead of "bin/ut.d"), so run `dub run --build=unittest` (somehow the unix style paths do not upset windows when you run with this command... confusing).

## 2) To run code coverage:
- Run `dub -b cov`. The coverage files will then be generated in `./coverage`.


# Draw Application #

## Information ##

## Commands ##

### Running the server ###
From the `client-and-server` dir, run the following command: `dub run :server`

This will run the first configuration inside the server subproject, which runs the server application.

### Running the client ###
From the `client-and-server` dir, run the following command: `dub run :client`

This will run the first configuration inside the client subproject, which runs the client application.

### Testing ###
To run all tests, perform the following command in a terminal inside the `client-and-server` directory: `dub test`

This will use unit-threaded to run all the tests located in the `./source`, `client/source`, and 
`server/source` directories.

NOTE: for some reason, in the same directory just running `dub run -c unitthreaded` (which should run the testing 
configuration specified in the dub.json) doesn't actually run any tests. This may be a bug with dub??

### Coverage ###
#### Server Coverage ####
From the `client-and-server` directory, run: `dub run :server -c cov`

Alternatively, from the `client` directory run: `dub run -c cov :server`

#### Client Coverage ####
From the `client-and-server` directory, run: `dub run :client -c cov`

Alternatively, from the `client` directory run: `dub run -c cov :client`

### Documentation ###
#### Basic ddocs generation ####
From the `client-and-server` directory, run: `dub build -b docs`  
And view the resulting documentation html in the `docs` directory. 

Alternatively, you can also run the following command in the same directory: `dub build --build=docs`

This _should_ build the documentation for the project. It may also build documentation for all 
dependencies, however those files may be put with the source code for said dependencies, 
and not in the `docs` folder.

#### Harbored-mod generation ####
From the `client-and-server` directory, run (you may need to accept the option to download harbored-mod): `dub run harbored-mod -- $(find ./client/source ./server/source -iname '*.d')`  

View the resulting documentation HTML in the `doc` directory. This will build interactive HTML documentation (start from the `index.html` file), for just the 
source files located in the `client/source` and `server/source` directories.

Alternatively, you can also run `dub run adrdox -- -i ./client-and-server` from the `DRaw` directory to build an interactive HTML documentation. View the resulting documentation HTML in the `generated-docs` directory.
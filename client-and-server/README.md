# Draw Application #

## Info ##

## Commands ##

### Running the client ###
From the `client-and-server` dir, run the following command:  
`dub run :client`

This will run the first configuration inside the client subproject, which runs the client application.

### Running the server ###
From the `client-and-server` dir, run the following command:  
`dub run :server`

This will run the first configuration inside the server subproject, which runs the server application.

### Testing ###
To run all tests, perform the following command in a terminal inside the `client-and-server` dir:  
`dub test`

This will use unitthreaded to run all the tests located in the `./source`, `client/source`, and 
`server/source` directories.

NOTE: for some reason, in the same directory just running `dub` (which should run the first 
configuration specified in the dub.json) doesn't actually run any tests. This may be a bug with dub??

### Coverage ###
#### Client Coverage ####
From the `client-and-server` directory, run:  
`dub run :client -c cov`

Alternatively, from the `client` directory run:  
`dub run -c cov`

#### Server Coverage ####
From the `client-and-server` directory, run:  
`dub run :server -c cov`

### Documentation ###
#### Basic ddocs generation ####
From the `client-and-server` directory, run:  
`dub build -b docs`  
And view the resulting documentation html in the `docs` directoy.

This _should_ build the documentation for the project. It may also build documentation for all 
dependencies, however those files may be put with the source code for said dependencies, 
and not in the docs folder.

#### Harbored-mod generation ####
From the `client-and-server` directory, run:
`dub run harbored-mod -- $(find ./client/source ./server/source -iname '*.d')`  
And view the resulting documentation html in the `doc` directory.

This will build interactive HTML documentation (start from the `index.html` file), for just the 
source files located in the `client/source` and `server/source` directories.


`
`
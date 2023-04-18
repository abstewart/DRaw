# Draw Application #

## Information ##

## Commands ##

### Running the server ###
From the `client-and-server` directory either run the following command: `dub run :server` OR `dub run :server -- {insert ip address} {insert port number}`

The former will run the server with the default ip address (localhost) and the default port number (50002). The latter will run the server with the inserted ip address and port number, assuming they are valid.

This will run the first configuration inside the server subproject, which runs the server application.

### Running the client ###
From the `client-and-server` directory, run the following command: `dub run :client`

This will run the first configuration inside the client subproject, which runs the client application.

### Testing ###
To run all tests, perform the following command in a terminal inside the `client-and-server` directory: `dub run -b unittest -c unittest`

This will use unit-threaded to run all the tests located in the `./source`, `client/source`, and 
`server/source` directories.

### Coverage ###
#### Server Coverage ####
From the `client-and-server` directory, run: `dub run :server -c cov`

Alternatively, from the `server` directory, run: `dub run -c cov`

#### Client Coverage ####
From the `client-and-server` directory, run: `dub run :client -c cov`

Alternatively, from the `client` directory, run: `dub run -c cov`

### Documentation ###
#### Basic ddocs Documentation Generation ####
From the `client-and-server` directory, run: `dub build -b docs`  
And view the resulting documentation html in the `docs` directory. 

Alternatively, you can also run the following command in the same directory: `dub build --build=docs`

This _should_ build the documentation for the project. It may also build documentation for all 
dependencies, however those files may be put with the source code for said dependencies, 
and not in the `docs` folder.

#### Harbored-mod Documentation Generation ####
From the `client-and-server` directory, run (you may need to accept the option to download harbored-mod): `dub run harbored-mod -- $(find ./client/source ./server/source -iname '*.d')`  

View the resulting documentation HTML in the `doc` directory. This will build an interactive HTML documentation (start from the `index.html` file), for just the 
source files located in the `client/source` and `server/source` directories.

#### Adrdox Documentation Generation ####
From the `DRaw` directory, run `dub run adrdox -- -i ./client-and-server`

View the resulting documentation HTML in the `generated-docs` directory. This will build an interactive HTML documentation.

### Notes ###
* If you are on a Mac computer, you may need to run: `export MACOSX_DEPLOYMENT_TARGET=11` in your terminal before running `dub`.
* When you are done running the client(s), closing the application down via exiting it or quitting it will shut down the client program. However, you have to `Control-c` the server program to shut down it down.
* The server and/or client may take a moment to start up (during the `dub` print outs) -- please be patient, they will load and start up correctly.
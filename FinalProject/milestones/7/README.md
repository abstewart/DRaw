# Draw Application #

## Note ##
Multiple Clients on 1 machine are only supported for MACOS

### Previous README tasks ###
- [x] Instructions on how to build your software should be written in this file.
	- This is especially important if you have added additional dependencies.
	- Assume someone who has not taken this class (i.e. you on the first day) would have read, build, and run your software from scratch.
- You should have at a minimum in your project.
	- [x] A dub.json in a root directory
    	- [x] This should generate a 'release' version of your software.
  - [x] Run your code with the latest version of d-scanner before committing your code (could be a GitHub action).
  - [x] (Optional) Run your code with the latest version of clang-tidy  (could be a GitHub action).


## Commands ##

### Running the server (debug Build Version) ###
From the [`client-and-server`](../../../client-and-server) directory either run the following command: `dub run :server -c runServer` OR `dub run :server -c runServer -- <ip address> <port number>`

The former will run the server with the default ip address (localhost) and the default port number (50002). The latter will run the server with the inserted ip address and port number, assuming they are valid.

This will run the debug configuration inside the server subproject, which runs the server application.

### Running the client (debug Build Version) ###
From the [`client-and-server`](../../../client-and-server) directory, run the following command: `dub run :client -c runClient`

This will run the debug configuration inside the client subproject, which runs the client application.

### Running the server (release Build Version) ###
From the [`client-and-server`](../../../client-and-server) directory either of the following commands: `dub run :server --build=release` OR `dub run :server --build=release -- <ip address> <port number>`

The former will run the server with the default ip address (localhost) and the default port number (50002). The latter will run the server with the inserted ip address and port number, assuming they are valid.

This will run the first configuration inside the server subproject, which runs the release build version of the server application.

### Running the client (release Build Version) ###
From the [`client-and-server`](../../../client-and-server) directory, run the following command: `dub run :client --build=release`

This will run the first configuration inside the client subproject, which runs the release build version of the client application.

### Running the client executable ###
One the executable is build with the above release build command. You can also run the executable generated directly. This executable must be run with a `images` folder in the same directory containing the [`icon.png`](../../../client-and-server/images/icon.png) and [`logo.png`](../../../client-and-server/images/logo.png) images inside. You can run the executable with `./draw_client`

### Running the server executable ###
Once the executable is built with the above server release build command, you can also run the server from the command line with the following command: `./draw_server <ip address> <port number>`


### Testing ###
To run all tests, perform the following command in a terminal inside the [`client-and-server`](../../../client-and-server) directory: `dub run -b unittest -c unittest`

This will use unit-threaded to run all the tests located in the [`client/source`](../../../client-and-server/client/source) and 
[`server/source`](../../../client-and-server/server/source) directories.

### Coverage ###
#### Server Coverage ####
From the [`client-and-server`](../../../client-and-server) directory, run: `dub run :server -c cov`

Alternatively, from the [`server`](../../../client-and-server/server) directory, run: `dub run -c cov`

#### Client Coverage ####
From the [`client-and-server`](../../../client-and-server) directory, run: `dub run :client -c cov`

Alternatively, from the [`client`](../../../client-and-server/client) directory, run: `dub run -c cov`

### Documentation ###
#### Basic ddocs Documentation Generation ####
From the [`client-and-server`](../../../client-and-server) directory, run: `dub build -b docs`  
And view the resulting documentation html in the `docs` directory. 

Alternatively, you can also run the following command in the same directory: `dub build --build=docs`

This _should_ build the documentation for the project. It may also build documentation for all 
dependencies, however those files may be put with the source code for said dependencies, 
and not in the `docs` folder.

#### Harbored-mod Documentation Generation ####
From the [`client-and-server`](../../../client-and-server) directory, run (you may need to accept the option to download harbored-mod): `dub run harbored-mod -- $(find ./client/source ./server/source -iname '*.d')`

View the resulting documentation HTML in the [`doc`](../../../client-and-server/doc) directory. This will build an interactive HTML documentation (start from the [`index.html`](../../../client-and-server/doc/index.html) file), for just the 
source files located in the `client/source` and `server/source` directories.

#### Adrdox Documentation Generation ####
From the root directory (`DRaw`), run `dub run adrdox -- -i ./client-and-server`

View the resulting documentation HTML (start with [`index.html`](../../../generated-docs/index.html)) in the `generated-docs` directory. This will build an interactive HTML documentation.

### Notes ###
* If you are on a Mac computer, you may need to run: `export MACOSX_DEPLOYMENT_TARGET=11` in your terminal before running `dub`.
* When you are done running the client(s), closing the application down via exiting it or quitting it will shut down the client program. However, you have to `Control-c` the server program to shut down it down.
* The server and/or client may take a moment to start up (during the `dub` print outs) -- please be patient, they will load and start up correctly.

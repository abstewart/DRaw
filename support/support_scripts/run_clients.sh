#!/bin/bash
###
### Run multiple clients (+ the server) with the same code without them interfering.
###
###

WORKING_REPO_DIR=C:/Users/sbabb/OneDrive/Documents/stevdev/sp23/DRaw-cicd-test
SECOND_REPO_DIR=C:/Users/sbabb/OneDrive/Documents/StevDev/sp23/DRaw-second-cicd-test

cp -r $WORKING_REPO_DIR $SECOND_REPO_DIR
cmd.exe /c start "Server Executable" cmd /c "cd $WORKING_REPO_DIR/client-and-server && dub run :server"
cmd.exe /c start "Client B" cmd /c "cd $WORKING_REPO_DIR/client-and-server && dub run :client"
cmd.exe /c start "Client A" cmd /c "cd $SECOND_REPO_DIR/client-and-server && dub run :client"
echo Done!
import std.concurrency;

void handleNetworking(Tid parent)
{
    Client network = new Client();

    for (bool active = true; active;)
    {
        // gives a 500 microsecond window for the main thread to trigger a send
        writeln("checking for send from parent");
        receiveTimeout(TIMEOUT_DUR, (bool noSendRequested) {
            writeln("explicit no send");
        }, (bool needToSend, Command commandToSend) {
            if (needToSend)
            {
                network.sendToServer(commandToSend.encode());
            }
        }, (OwnerTerminated) { active = false; });
        // receives data from our server, note our server is non-blocking
        writeln("checking for data from server");
        Command remoteCommand = network.receiveFromServer();
        // if we get a command we need to send it to our parent thread
        if (remoteCommand)
        {
            parent.send(remoteCommand);
        }

    }
}

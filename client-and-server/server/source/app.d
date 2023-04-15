// Imports.
import std.stdio;
import std.getopt;

import model.server_network;

/// Server app. Main method -- run the application. Entry point for the program.
void main(string[] args)
{
    bool disable_main_loop = false;
    auto helpInformation = getopt(args, "disable_main_loop",
            "Set to true to prevent blocking via main loop. Defaults to false.",
            &disable_main_loop);

    if (helpInformation.helpWanted)
    {
        defaultGetoptPrinter("Help info for this program.", helpInformation.options);
    }

    writeln("Awaiting client connections");
    if (!disable_main_loop)
    {
        Server ourServer = new Server();
        ourServer.handleReception();
    }
}

private import std.stdio : writeln;
private import std.getopt;
private import std.conv;

private import model.server_network;
private import util.Validator;

/**
 * Provides entry point for the server program.
 */
void main(string[] args)
{
    // If the number of command line arguments is not 0 or 2, alert the user and terminate the program.
    if (args.length == 2 || args.length > 3)
    {
        writeln("Could not start up server. Please try again. Expecting this format in terminal - 'dub run :server' OR 'dub run :server {ip address} " ~ " {port number}'");
        return;
    }

    debug
    {
        if (args.length == 3)
        {
            writeln("isValidIPAddress(\"" ~ args[1] ~ "\") = " ~ to!string(
                    Validator.isValidIPAddress(args[1])));
            writeln("isValidPort(\"" ~ args[2] ~ "\") = " ~ to!string(
                    Validator.isValidPort(args[2])));
        }
    }

    // If there are no command line arguments OR there are 2 command line arguments create a server.
    if (args.length == 1 || (Validator.isValidIPAddress(args[1]) && Validator.isValidPort(args[2])))
    {
        bool disable_main_loop = false;
        auto helpInformation = getopt(args, "disable_main_loop",
                "Set to true to prevent blocking via main loop. Defaults to false.",
                &disable_main_loop);

        if (helpInformation.helpWanted)
        {
            defaultGetoptPrinter("Help info for this program.", helpInformation.options);
        }

        writeln("Running server. Awaiting client connections.");
        if (!disable_main_loop)
        {
            Server ourServer;
            if (args.length == 1)
            {
                debug
                {
                    writeln("Using default port and IP.");
                }

                ourServer = new Server();
            }
            else
            {
                debug
                {
                    writeln("Using user defined port and IP.");
                }

                string ipAddress = args[1];
                ushort portNumber = to!ushort(args[2]);
                ourServer = new Server(ipAddress, portNumber);
            }

            ourServer.handleReception();
        }
    }
    else
    {
        debug
        {
            writeln("Invalid ip address (\"%s\") and/or port number (\"%s\"). Could not start up server. Please try again.",
                    args[1], args[2]);
            writeln("Expecting this format in the terminal - 'dub run :server' OR 'dub run :server {ip address} "
                    ~ " {port number}'");
        }
    }
}

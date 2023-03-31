import std.stdio;
import server_network : Server;

/// Main function. Entry point for the program.
void main()
{
    Server ourServer = new Server("localhost", 51111, 4);

	writeln("Awaiting client connections");

    ourServer.handleReception();
}
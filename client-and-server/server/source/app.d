private import std.stdio;
private import std.getopt;
private import std.string : isNumeric;
private import std.conv;
private import std.regex;
private import std.algorithm.comparison : equal;
private import std.logger;

private import model.server_network;

/**
 * Provides entry point for the server program.
 */
void main(string[] args)
{
    auto sLogger = new FileLogger("Server Log File"); // Will only create a new file if one with this name does not already exist.
    const int MIN_REQUIRED = 3;
    if (args.length != MIN_REQUIRED)
    {
        stderr.writeln("Invalid command line arguments. See Server Log File for more information.");
        sLogger.warning("Could not start up server. Please try again. Expecting this format in terminal - 'dub run :server {ip address} " ~ " {port number}'");
        return;
    }

    sLogger.info("isValidIPAddress(\"" ~ args[1] ~ "\") = " ~ to!string(isValidIPAddress(args[1])));
    sLogger.info("isValidPort(\"" ~ args[2] ~ "\") = " ~ to!string(isValidPort(args[2])));

    if (isValidIPAddress(args[1]) && isValidPort(args[2]))
    {
        sLogger.info("Valid ip address and port number!");
        string ipAddress = args[1];
        ushort portNumber = to!ushort(args[2]);
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
            Server ourServer = new Server(ipAddress, portNumber);
            ourServer.handleReception();
        }
    }
    else
    {
        stderr.writeln("Invalid command line arguments. See Server Log File for more information.");
        sLogger.warning(
                "Invalid ip address (\"%s\") and/or port number (\"%s\"). Could not start up server. Please try again.",
                args[1], args[2]);
        sLogger.warning("Expecting this format in the terminal - 'dub run :server {ip address} " ~ " {port number}'");
    }
}

/**
 * Validates the given IP address.
 *
 * An IP address is valid if it is in IPv4 dotted-decimal form a.b.c.d where 0 <= a,b,c,d <= 255
 * or if IP address is a hostname that will resolve.
 *
 * Params:
 *       - ipAddress : string : the IP address to validate
 *
 * Returns:
 *       - status : bool : true if the IP address is valid, false if not
 */
private bool isValidIPAddress(string ipAddress)
{
    // Regex expression for validating IPv4. (https://ihateregex.io/expr/ip/)
    auto r = regex(
            r"(\b25[0-5]|\b2[0-4][0-9]|\b[01]?[0-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}");
    return ipAddress.equal("localhost") || matchFirst(ipAddress, r);
}

/**
 * Validates the given port.
 *
 * A valid port is any port that is not reserved (1-1024) and is a valid port number (1-65535).
 *
 * Params:
 *       - port : string : the port number to check
 *
 * Returns:
 *       - status : bool : true if the port is valid, false if not
 */
private bool isValidPort(string port)
{
    const ushort LOWRANGE = 1;
    const ushort SYSPORT = 1024;
    if (isNumeric(port))
    {
        try
        {
            ushort portNum = to!ushort(port);
            // Do not need to check for the high range of 65535 because to!ushort will handle that for us.
            if (portNum < LOWRANGE)
            {
                return false;
            }
            if (portNum <= SYSPORT)
            {
                return false;
            }
        }
        catch (ConvException ce)
        {
            return false;
        }

        return true;
    }
    return false;
}

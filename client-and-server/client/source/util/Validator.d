module util.Validator;

private import std.regex;
private import std.algorithm.comparison : equal;
private import std.string : isNumeric;
private import std.conv;
private import std.typecons;

class Validator
{
public:
    /**
     * Validates the given username.
     *
     * A username is valid if it has at least one letter or number and no trailing whitespace.
     *
     * Params:
     *       - username : string : the username to validate
     *
     * Returns:
     *       - status : bool : true if the username is valid, false if not
     */
    static bool isValidUsername(string username)
    {
        if (username is null)
        {
            return false;
        }
        // (https://stackoverflow.com/questions/34974942/regex-for-no-whitespace-at-the-beginning-and-end)
        // Regular expression that prevents symbols and only allows letters and numbers.
        // Allows for spaces between words. But there cannot be any leading or trailing spaces.
        auto r = regex(r"^[-a-zA-Z0-9-()]+(\s+[-a-zA-Z0-9-()]+)*$");
        return !username.equal("") && matchFirst(username, r);
    }

    /**
    * Testing the isValidUsername() method with valid usernames.
    */
    @("Testing isValidUsername valid")
    unittest
    {
        assert(isValidUsername("Mike Shah"));
        assert(isValidUsername("Rohit"));
        assert(isValidUsername("Bob"));
        assert(isValidUsername("User12"));
    }

    /**
    * Testing the isValidUsername() method with invalid usernames.
    */
    @("Testing isValidUsername invalid")
    unittest
    {
        assert(!isValidUsername(null));
        assert(!isValidUsername("   Mike"));
        assert(!isValidUsername(""));
        assert(!isValidUsername("   "));
        assert(!isValidUsername("  d"));
        assert(!isValidUsername("User!!!"));
        assert(!isValidUsername("\n"));
        assert(!isValidUsername("\t\t\r"));
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
    static bool isValidIPAddress(string ipAddress)
    {
        if (ipAddress is null)
        {
            return false;
        }
        // Regex expression for validating IPv4. (https://ihateregex.io/expr/ip/)
        auto r = regex(
                r"(\b25[0-5]|\b2[0-4][0-9]|\b[01]?[0-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}");
        return ipAddress.equal("localhost") || matchFirst(ipAddress, r);
    }

    /**
    * Testing the isValidIPAddress() method with valid ip addresses.
    */
    @("Testing isValidIPAddress valid")
    unittest
    {
        assert(isValidIPAddress("localhost"));
        assert(isValidIPAddress("192.168.1.1"));
        assert(isValidIPAddress("127.0.0.1"));
        assert(isValidIPAddress("0.0.0.0"));
        assert(isValidIPAddress("255.255.255.255"));
        assert(isValidIPAddress("1.2.3.4"));
        assert(!isValidIPAddress("256.256.256.256"));
        assert(!isValidIPAddress("999.999.999.999"));
        assert(!isValidIPAddress("1.2.3"));
    }

    /**
    * Testing the isValidIPAddress() method with invalid ip addresses.
    */
    @("Testing isValidIPAddress invalid")
    unittest
    {
        assert(!isValidIPAddress(null));
        assert(!isValidIPAddress(""));
        assert(!isValidIPAddress("localHOST"));
        assert(!isValidIPAddress("testing"));
        assert(!isValidIPAddress("256.256.256.256"));
        assert(!isValidIPAddress("999.999.999.999"));
        assert(!isValidIPAddress("1.2.3"));
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
    static bool isValidPort(string port)
    {
        if (port is null)
        {
            return false;
        }
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

    /**
    * Testing the isValidPort() method with valid port numbers.
    */
    @("Testing isValidPort valid")
    unittest
    {
        assert(isValidPort("50002"));
        assert(isValidPort("50001"));
        assert(isValidPort("50004"));
        assert(isValidPort("65535"));
        assert(isValidPort("1025"));
        assert(isValidPort("60000"));
    }

    /**
    * Testing the isValidPort() method with invalid port numbers.
    */
    @("Testing isValidPort invalid")
    unittest
    {
        assert(!isValidPort(null));
        assert(!isValidPort("0"));
        assert(!isValidPort(""));
        assert(!isValidPort("1024"));
        assert(!isValidPort("10"));
        assert(!isValidPort("1"));
        assert(!isValidPort("65536"));
        assert(!isValidPort("70000"));
        assert(!isValidPort("Testing"));
        assert(!isValidPort("50002a"));
    }
}

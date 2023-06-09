module model.network.client;

import std.socket;

debug
{
    private import std.stdio : writeln;
}
import std.typecons;
import std.datetime;

import controller.commands.Command;

auto SOCKET_TIMEOUT = 1.msecs;
string DEFAULT_SOCKET_IP = "localhost";
ushort DEFAULT_PORT_NUMBER = 50002;

/**
 * Class providing client networking features. Provides functionatity for binding to, sending to, and receiving from a socket.
 */
class Client
{
private:
    string ipAddress;
    ushort portNumber;
    TcpSocket sock;
    bool socketOpen;

public:
    /**
     * Constructs a client socket object with a given IP and port number.
     *
     * Params: 
     *        - ipAdress   : string : the IP address to bind, defaults to localhost
     *        - portNumber : ushort : the port number to bind, defaults to 50002
     */
    this(string ipAddress = DEFAULT_SOCKET_IP, ushort portNumber = DEFAULT_PORT_NUMBER)
    {
        this.ipAddress = ipAddress;
        this.portNumber = portNumber;
        this.sock = new TcpSocket(AddressFamily.INET);
        // This timeout is broken on windows (500 ms offset).
        this.sock.setOption(SocketOptionLevel.SOCKET, SocketOption.RCVTIMEO, SOCKET_TIMEOUT);
        this.sock.connect(new InternetAddress(this.ipAddress, this.portNumber));
        this.socketOpen = true;
    }

    /**
     * Closes the socket upon object deconstruction.
     */
    ~this()
    {
        if (this.socketOpen)
        {
            this.sock.shutdown(SocketShutdown.BOTH);
            this.sock.close();
        }
        debug
        {
            writeln("Closed socket in Client destructor.");
        }
    }

    /**
     * Receives any data coming in from the server within the timeout period. Closes the socket upon socket errors outside of blocking.
     * 
     * Returns:
     *          - (message, recv) : Tuple!(char[1024], long) : message contents receieved and length in bytes
     */
    Tuple!(char[1024], long) receiveFromServer()
    {
        char[1024] message;
        long recv = 0;
        if (this.socketOpen)
        {
            recv = this.sock.receive(message);
            if (recv > 0)
            {
                return Tuple!(char[1024], long)(message, recv);
            }
            else if (recv == 0)
            {
                this.sock.shutdown(SocketShutdown.BOTH);
                this.sock.close();
                this.socketOpen = false;
            }
            else if (recv == Socket.ERROR)
            {
                if (!wouldHaveBlocked())
                {
                    debug
                    {
                        writeln("Socket error during reception.");
                    }
                    this.sock.shutdown(SocketShutdown.BOTH);
                    this.sock.close();
                    this.socketOpen = false;
                }
            }
            else
            {
                debug
                {
                    writeln("Unknown value received from server.");
                }
            }
        }
        return Tuple!(char[1024], long)(message, recv);
    }

    /**
     * Sends the given packet data to the server.
     *
     * Params:
     *        - packetData : string : the packet data to send
     */
    void sendToServer(string packetData)
    {
        if (this.socketOpen)
        {
            debug
            {
                import std.format;

                writeln("%s -> Server".format(packetData));
            }

            this.sock.send(packetData);
        }
    }

    /**
     * Checks the status of the socket.
     *
     * Returns:
     *         - bool : whether or not the socket is currently open.
     */
    bool isSocketOpen()
    {
        return this.socketOpen;
    }
}

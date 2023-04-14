module model.network.client;

import std.socket;
import std.stdio;
import std.parallelism;
import std.typecons;
import std.datetime;

import controller.commands.Command;

auto SOCKET_TIMEOUT = 1.msecs;

string DEFAULT_SOCKET_IP = "localhost";
ushort DEFAULT_PORT_NUMBER = 51111;
int MESSAGE_BUFFER_SIZE = 1024;

class Client
{
    private:
    string ipAddress;
    ushort portNumber;
    TcpSocket sock;
    bool socketOpen;

    public:
    this(string ipAddress = DEFAULT_SOCKET_IP, ushort portNumber = DEFAULT_PORT_NUMBER)
    {
        this.ipAddress = ipAddress;
        this.portNumber = portNumber;
        this.sock = new TcpSocket(AddressFamily.INET);
        // this timeout is broken on windows (500 ms offset)
        this.sock.setOption(SocketOptionLevel.SOCKET, SocketOption.RCVTIMEO, SOCKET_TIMEOUT);
        this.sock.connect(new InternetAddress(this.ipAddress, this.portNumber));
        this.socketOpen = true;
    }

    ~this()
    {
        this.sock.close();
    }

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
                this.sock.close();
                this.socketOpen = false;
            }
            else if (recv == Socket.ERROR)
                {
                    if (wouldHaveBlocked())
                    {
                        writeln("Socket would have blocked");
                    }
                    else
                    {
                        writeln("Socket lerror");
                        this.sock.close();
                        this.socketOpen = false;
                    }
                }
                else
                {
                    writeln("Unknown received value.");
                }
        }
        return Tuple!(char[1024], long)(message, recv);
    }

    void sendToServer(char[] packetData)
    {
        if (this.socketOpen)
        {
            this.sock.send(packetData);
        }

    }

    void sendToServer(string packetData)
    {
        writeln("sending", packetData);
        char[] packet;
        packet ~= packetData;
        this.sock.send(packet);
    }

    bool isSocketOpen()
    {
        return this.socketOpen;
    }
}

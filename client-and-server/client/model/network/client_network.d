module client_network;

import std.socket;
import std.stdio;
import std.parallelism;
import std.typecons;

import command;
import encode_decode;
import application_state : ApplicationState;
import deque : Deque;

string DEFAULT_SOCKET_IP = "localhost";
ushort DEFAULT_PORT_NUMBER = 51111;
int MESSAGE_BUFFER_SIZE = 1024;

Command parseCommand(char[] message, long size)
{
    Command someCommand = decodePacketToCommand(message, size);
    return someCommand;
}

// void handleReception(Client clientNetwork, Deque!Command cStack) {
//     long recv = clientNetwork.receiveFromServer( cStack);
// }

class Client
{
    private string ipAddress;
    private ushort portNumber;
    private TcpSocket sock;
    private bool socketOpen;

    this(string ipAddress = DEFAULT_SOCKET_IP, ushort portNumber = DEFAULT_PORT_NUMBER)
    {
        this.ipAddress = ipAddress;
        this.portNumber = portNumber;
        this.sock = new TcpSocket(AddressFamily.INET);
        this.sock.blocking = false;
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
        long recv = this.sock.receive(message);
        if (recv > 0)
        {
            return Tuple!(char[1024], long)(message, recv);
        }
        else if (recv == 0)
        {
            // writeln("Server closed connection");
            this.sock.close();
            this.socketOpen = false;
        }
        else if (recv == Socket.ERROR)
        {
            // writeln("Socket error");
        }
        else
        {
            // writeln("Unknown received value.");
        }
        if (wouldHaveBlocked())
        {
            // writeln("receiving will block");
        }
        return Tuple!(char[1024], long)(message, recv);
    }

    void sendToServer(char[] packetData)
    {
        this.sock.send(packetData);
    }

    void sendToServer(string packetData)
    {
        char[] packet;
        packet ~= packetData;
        this.sock.send(packet);
    }

    bool isSocketOpen()
    {
        return this.socketOpen;
    }
}

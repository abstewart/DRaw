module server_network;

import controller.commands.Command;
import EncodeDecode;

import std.socket;
import std.stdio;
import std.parallelism;
import std.conv;

ushort MAX_ALLOWED_CONNECTIONS = 1;
string DEFAULT_SOCKET_IP = "localhost";
ushort DEFAULT_PORT_NUMBER = 51111;
int MESSAGE_BUFFER_SIZE = 4096;

Command parseCommand(char[] message, long size)
{
    Command someCommand = decodePacketToCommand(message, size);
    return someCommand;
}

void notifyAllExcept(Socket[int] clients, Command command, int ckey)
{
    char[] message = command.encode();
    int[] curKeys = clients.keys();
    foreach (key; parallel(curKeys))
    {
        if (key == ckey)
        {
            continue;
        }
        Socket client = clients[key];
        client.send(message);
    }
}

class Server
{
    private string ipAddress;
    private ushort portNumber;
    private TcpSocket sock;
    private SocketSet sockSet;
    private Socket[int] connectedClients;
    private int countMessages;
    private bool isRunning;
    private long bufferSize;
    private static int clientCount;
    private Command[] commandStack = [];

    this(string ipAddress = DEFAULT_SOCKET_IP, ushort portNumber = DEFAULT_PORT_NUMBER,
            ushort allowedConnections = MAX_ALLOWED_CONNECTIONS,
            long bufferSize = MESSAGE_BUFFER_SIZE)
    {
        this.ipAddress = ipAddress;
        this.portNumber = portNumber;
        this.sock = new TcpSocket(AddressFamily.INET);
        this.sock.bind(new InternetAddress(this.ipAddress, this.portNumber));
        this.sock.listen(allowedConnections);
        this.isRunning = true;
        this.sockSet = new SocketSet();
        this.bufferSize = bufferSize;
    }

    ~this()
    {
        this.sock.close();
    }

    void pollForMessagesAndClients()
    {
        if (Socket.select(this.sockSet, null, null))
        {
            if (this.sockSet.isSet(this.sock))
            {
                Socket newSocket = this.sock.accept();
                this.connectedClients[++this.clientCount] = newSocket;
                writeln("> client", this.clientCount, " added to connectedClients list");
            }
            int[] curKeys = this.connectedClients.keys();
            foreach (key; parallel(curKeys))
            {
                Socket client = this.connectedClients[key];
                if (this.sockSet.isSet(client))
                {
                    char[1024] buffer;
                    long recv = client.receive(buffer);
                    if (recv > 0)
                    {
                        writeln("received", buffer[0 .. recv]);
                        Command recvCommand = parseCommand(buffer, recv);
                        notifyAllExcept(this.connectedClients, recvCommand, key);
                    }
                    else if (recv == 0)
                    {
                        writeln("Client closed connection: ", key);
                        client.close();
                        this.connectedClients.remove(key);
                    }
                    else if (recv == Socket.ERROR)
                    {
                        writeln("Socket error");
                    }
                    else
                    {
                        writeln("Unknown socket reception return value");
                    }
                }
            }
        }
    }

    void initializeSocketSet()
    {
        // Clear the readSet
        this.sockSet.reset();
        // Add the server
        this.sockSet.add(this.sock);
        foreach (client; this.connectedClients)
        {
            this.sockSet.add(client);
        }
    }

    void handleReception()
    {
        while (this.isRunning)
        {
            this.initializeSocketSet();
            this.pollForMessagesAndClients();
        }
    }
}

module model.server_network;

// Imports.
import controller.commands.Command;

import std.socket;
import std.stdio;
import std.parallelism;
import std.conv;
import std.typecons;
import std.array;
import std.algorithm;
import core.thread;

import model.packets.packet;
import view.MyWindow;

private import model.ServerState;

ushort MAX_ALLOWED_CONNECTIONS = 100;
string DEFAULT_SOCKET_IP = "localhost";
ushort DEFAULT_PORT_NUMBER = 50002;
int MESSAGE_BUFFER_SIZE = 1024;

void serverResolveRemotePackets(string packet)
{
    immutable int packetType = to!int(packet[0]) - '0';
    switch (packetType)
    {
    case (USER_CONNECT_PACKET):
        //todo fix this
        //Tuple!(string, int, bool) info = decodeUserConnPacket(packet, 0);
        //if (info[2])
        //{
        //    ServerState.addConnectedUser(info[0], info[1]);
        //}
        //else
        //{
        //    ServerState.removeConnectedUser(info[1]);
        //}
        break;
    case (DRAW_COMMAND_PACKET):
        ServerState.addToCommandHistory(packet);
        break;
    case (CHAT_MESSAGE_PACKET):
        ServerState.addChatPacket(packet);
        break;
    case (UNDO_COMMAND_PACKET):
        auto undoCmd = decodeUndoCommandPacket(packet, 0);
        string toCheck = "1," ~ undoCmd[0] ~ "," ~ to!string(
                undoCmd[1]) ~ "," ~ to!string(undoCmd[2]);
        string[] acc;
        foreach (cmdPacket; ServerState.getCommandHistory())
        {
            writeln("comparing: ", toCheck, ":: with: ", cmdPacket);
            if (cmdPacket.startsWith(toCheck))
            {
                continue;
            }
            acc ~= cmdPacket;
        }
        ServerState.setCommandHistory(acc);
        break;
    case (CANVAS_SYNCH_PACKET):
        break;
    default:
        writeln("no case found");
        break;
    }
}

Tuple!(string, int, Command) parseCommand(string message, long size)
{
    //todo fix this when server state is implemented, this will likely cause NPR exceptions
    MyWindow window;
    return decodeUserDrawCommand(message, size, window);
}
//parallel
void notifyAllExcept(Socket[int] clients, string message, int ckey)
{
    int[] curKeys = clients.keys();
    foreach (key; curKeys)
    {
        if (key == ckey)
        {
            continue;
        }
        Socket client = clients[key];
        client.send(message);
    }
}
//parallel
void notifyAll(Socket[int] clients, string message)
{
    int[] curKeys = clients.keys();
    foreach (key; curKeys)
    {
        Socket client = clients[key];
        client.send(message);
    }
}

void sendSyncUpdate(Socket[int] clients, int ckey)
{
    Socket client = clients[ckey];

    foreach_reverse (cmd; ServerState.getCommandHistory())
    {
        writeln("sending sync: ", cmd);
        Thread.sleep(1.msecs);
        client.send(cmd);
    }
    foreach (chat; ServerState.getChatHistory())
    {
        writeln("sending sync: ", chat);
        Thread.sleep(1.msecs);
        client.send(chat);
    }
    writeln(ServerState.getCommandHistory().length);
}

class Server
{
    private string ipAddress;
    private ushort portNumber;
    private TcpSocket sock;
    private SocketSet sockSet;
    private Socket[int] connectedClients;
    string[int] connectedUsers;
    string[] chatHistory = [];
    string[] commandHistory = [];
    private string[int] users;
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
                char[1024] buffer;
                long recv = newSocket.receive(buffer);
                Tuple!(string, int, bool) userIdConnStatus = decodeUserConnPacket(to!string(buffer),
                        recv);
                writeln("> user ", userIdConnStatus[0], " successfully connected");
                this.users[this.clientCount] = userIdConnStatus[0];
                notifyAll(this.connectedClients, encodeUserConnPacket(userIdConnStatus[0],
                        this.clientCount, userIdConnStatus[2]));
                //todo look into not hanging server while syncing
                writeln("sending sync update");
                sendSyncUpdate(this.connectedClients, this.clientCount);
            }
            int[] curKeys = this.connectedClients.keys();
            //parallel
            foreach (key; curKeys)
            {
                Socket client = this.connectedClients[key];
                if (this.sockSet.isSet(client))
                {
                    char[1024] buffer;
                    long recv = client.receive(buffer);
                    if (recv > 0)
                    {
                        writeln("received", buffer[0 .. recv]);

                        serverResolveRemotePackets(to!string(buffer[0 .. recv]));
                        writeln(ServerState.getCommandHistory().length);

                        notifyAllExcept(this.connectedClients, to!string(buffer[0 .. recv]), key);
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

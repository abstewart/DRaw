module model.server_network;

private import std.socket;
private import std.stdio;
private import std.conv;
private import std.typecons;
private import std.array;
private import std.algorithm;
private import core.thread;

debug
{
    private import std.logger;
}

private import model.packets.packet;
private import view.MyWindow;
private import controller.commands.Command;
private import model.ServerState;

ushort MAX_ALLOWED_CONNECTIONS = 100;
string DEFAULT_SOCKET_IP = "localhost";
ushort DEFAULT_PORT_NUMBER = 50002;
int MESSAGE_BUFFER_SIZE = 1024;

/**
 * Resolves the given packet with the server's state.
 *
 * Params:
 *       - packet : string : packet to resolve
 */
void serverResolveRemotePacket(string packet)
{
    debug
    {
        auto sLogger = new FileLogger("Server Log File"); // Will only create a new file if one with this name does not already exist.
    }
    immutable int packetType = to!int(packet[0]) - '0';
    switch (packetType)
    {
    case (USER_CONNECT_PACKET):
        Tuple!(string, int, bool) info = decodeUserConnPacket(packet, 0);
        if (info[2])
        {
            ServerState.addConnectedUser(info[0], info[1]);
        }
        else
        {
            ServerState.removeConnectedUser(info[1]);
        }
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
            if (cmdPacket.startsWith(toCheck))
            {
                continue;
            }
            acc ~= cmdPacket;
        }
        ServerState.setCommandHistory(acc);
        break;
    default:
        debug
        {
            sLogger.info("In serverResolveRemotePacket's switch statement. No case found.");
        }

        break;
    }
}

/**
 * Tests the resolution of chat packets.
 */
@("Tests the resolution of chat packets")
unittest
{
    ServerState.wipeChatHistory();
    assert(ServerState.getChatHistory().length == 0);
    string chatPacket = "3,ben%s,1,100000000,hello this is message %s\r";
    for (int i = 1; i <= 100; i++)
    {
        serverResolveRemotePacket(chatPacket.format(i, i));
        assert(ServerState.getChatHistory().length == i);
    }
}

/**
 * Tests the resolution of undo packets.
 */
@("Tests the resolution of undo packets")
unittest
{
    ServerState.setCommandHistory([]);
    assert(ServerState.getCommandHistory().length == 0);

    string[] toSet = [];
    string samplePacket = "1,%s,1,1,1,1,1,1,1|1|1|1\r";
    for (int i = 1; i <= 20; i++)
    {
        for (int j = 1; j <= 100; j++)
        {
            toSet ~= samplePacket.format(i);
        }
    }
    string undoPacket = "2,%s,1,1\r";
    ServerState.setCommandHistory(toSet);
    assert(ServerState.getCommandHistory().length == 2000);

    for (int k = 1; k <= 10; k++)
    {
        serverResolveRemotePacket(undoPacket.format(k));
        assert(ServerState.getCommandHistory().length == 2000 - k * 100);
    }
}

/**
* Tests the resolution of drawing packets.
*/
@("Tests the resolution of drawing packets")
unittest
{
    ServerState.setCommandHistory([]);
    assert(ServerState.getCommandHistory().length == 0);

    string samplePacket = "1,drawCommandPacket,%s,1,1,1,1,1,1|1|1|1\r";
    for (int i = 1; i <= 10; i++)
    {
        string toUpdateWith = samplePacket.format(i);
        serverResolveRemotePacket(toUpdateWith);
        auto updatedHistory = ServerState.getCommandHistory();
        assert(updatedHistory.length == i);
        assert(updatedHistory[$ - i] == toUpdateWith);
    }
}

/**
 * Tests resolution of user connection packets.
 */
@("Tests resolution of user connection packets")
unittest
{
    ServerState.wipeConnectedUsers();
    assert(ServerState.getConnectedUsers().keys().length == 0);

    string connPacket = "0,user,-1,1\r";
    serverResolveRemotePacket(connPacket);

    assert(ServerState.getConnectedUsers().keys().length == 1);
    string[int] connUsers = ServerState.getConnectedUsers();
    assert(connUsers[-1] == "user");

    string disconnPacket = "0,user,-1,0\r";
    serverResolveRemotePacket(disconnPacket);

    assert(ServerState.getConnectedUsers().keys().length == 0);
}

/**
 * Notifies all clients in the given hashmap of the given message except the client with the given key.
 *
 * Params:
 *       - clients : Socket[int] : hashmap of client id to socket
 *       - message : string : message to notify clients with
 *       - ckey    : int : key to client socket in set to not notify
 */
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

/**
 * Notifies all clients in the given hashmap of the given message.
 *
 * Params: 
 *       - clients : Socket[int] : hashmap of client id to socket
 *       - message : string : message to notify clients of
 */
void notifyAll(Socket[int] clients, string message)
{
    int[] curKeys = clients.keys();
    foreach (key; curKeys)
    {
        Socket client = clients[key];
        client.send(message);
    }
}

/**
 * Sends the client of the given id the current server state.
 *
 * Params:
 *       - clients : Socket[int] : list of clients
 *       - ckey    : int : client id to sync
 */
void sendSyncUpdate(Socket[int] clients, int ckey)
{
    debug
    {
        auto sLogger = new FileLogger("Server Log File"); // Will only create a new file if one with this name does not already exist.
    }

    Socket client = clients[ckey];

    foreach_reverse (cmd; ServerState.getCommandHistory())
    {
        debug
        {
            sLogger.info("Sending sync: ", cmd);
        }

        Thread.sleep(1.msecs);
        client.send(cmd);
    }
    foreach (chat; ServerState.getChatHistory())
    {
        debug
        {
            sLogger.info("Sending sync: ", chat);
        }

        Thread.sleep(1.msecs);
        client.send(chat);
    }
    debug
    {
        sLogger.info("The command history length = ", ServerState.getCommandHistory().length);
    }
}

/**
 * Class implementing all server and consensus functionalities for the application.
 */
class Server
{
    private string ipAddress;
    private ushort portNumber;
    private TcpSocket sock;
    private SocketSet sockSet;
    private Socket[int] connectedClients;
    private string[int] users;
    private int countMessages;
    private bool isRunning;
    private long bufferSize;
    private static int clientCount;
    private Command[] commandStack = [];
    debug
    {
        private FileLogger sLogger;
    }

    /**
     * Constructs the server object.
     *
     * Params:
     *       - ipAddress          : string : the ipAddress to bind to
     *       - portNumber         : ushort : the port number to bind to
     *       - allowedConnections : ushort : the number of allowed simultaneous connections to the server
     *       - bufferSize         : long : the buffer size of the socket
     */
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
        debug
        {
            this.sLogger = new FileLogger("Server Log File"); // Will only create a new file if one with this name does not already exist.
        }
    }

    /**
     * Closes the socket upon destruction.
     */
    ~this()
    {
        this.sock.close();
    }

    /**
     * Polls the socket set for new connections, if one has connected adds it to the server's state.
     * When socket receives a new packet, stores packet in state and relays to all clients.
     */
    void pollForMessagesAndClients()
    {
        if (Socket.select(this.sockSet, null, null))
        {
            if (this.sockSet.isSet(this.sock))
            {
                Socket newSocket = this.sock.accept();
                this.connectedClients[++this.clientCount] = newSocket;
                char[1024] buffer;
                long recv = newSocket.receive(buffer);
                Tuple!(string, int, bool) userIdConnStatus = decodeUserConnPacket(to!string(buffer),
                        recv);
                debug
                {
                    sLogger.info("> user ", userIdConnStatus[0], " successfully connected");
                }

                this.users[this.clientCount] = userIdConnStatus[0];
                notifyAll(this.connectedClients, encodeUserConnPacket(userIdConnStatus[0],
                        this.clientCount, userIdConnStatus[2]));
                sendSyncUpdate(this.connectedClients, this.clientCount);
            }
            int[] curKeys = this.connectedClients.keys();

            foreach (key; curKeys)
            {
                Socket client = this.connectedClients[key];
                if (this.sockSet.isSet(client))
                {
                    char[1024] buffer;
                    long recv = client.receive(buffer);
                    if (recv > 0)
                    {
                        debug
                        {
                            sLogger.info("In server_network.d. Server received this packet: ",
                                    buffer[0 .. recv]);
                        }

                        serverResolveRemotePacket(to!string(buffer[0 .. recv]));
                        debug
                        {
                            sLogger.info("The command history length = ",
                                    ServerState.getCommandHistory().length);
                        }

                        notifyAllExcept(this.connectedClients, to!string(buffer[0 .. recv]), key);
                    }
                    else if (recv == 0)
                    {
                        debug
                        {
                            sLogger.info("Client closed connection: ", key);
                        }

                        client.close();
                        this.connectedClients.remove(key);
                    }
                    else if (recv == Socket.ERROR)
                    {
                        debug
                        {
                            sLogger.warning("Socket error.");
                        }
                    }
                    else
                    {
                        debug
                        {
                            sLogger.warning("Unknown socket reception return value.");
                        }
                    }
                }
            }
        }
    }

    /**
     * Initializes the socket set and adds client sockets to reset update status.
     */
    void initializeSocketSet()
    {
        // Clear the readSet.
        this.sockSet.reset();
        // Add the server.
        this.sockSet.add(this.sock);
        foreach (client; this.connectedClients)
        {
            this.sockSet.add(client);
        }
    }

    /**
     * Runs the loop of socket set initialization and polling.
     */
    void handleReception()
    {
        while (this.isRunning)
        {
            this.initializeSocketSet();
            this.pollForMessagesAndClients();
        }
    }
}

module model.Communicator;

import std.concurrency;
import std.stdio : writeln;
import std.typecons;
import std.algorithm;
import std.datetime;

import model.network.thread_entry;
import model.ApplicationState;
import model.packets.packet;
import controller.commands.Command;

auto THREAD_TIMEOUT_DUR = 5000.msecs;

/**
 * Class intended to represent a communication object between the main and network thread.
 */
class Communicator
{
private:
    static bool threadActive = false;
    static bool connectionStatus = false;
    static Tid childThread;
    static Communicator instance = null;

    /**
     * Constructs a Communicator object given a port, ip, and username.
     * Attempts to connect to given and port ip with given username.
     *
     * Params:
     *       - port     : ushort : port number to connect to 
     *       - ip       : string : ip address to connect to 
     *       - username : string : username to connect with
     */
    this(ushort port, string ip, string username)
    {
        // Spawn thread and wait for connection.
        threadActive = true;
        childThread = spawn(&handleNetworking, thisTid, ip, port);
        int clientId = ApplicationState.getClientId();
        // Create connection packet (connected -- true) and send it to the server.
        string connReqPacket = encodeUserConnPacket(username, clientId, true);
        send(this.childThread, connReqPacket);

        // Receive an acknowledgement packet from the server and update the application state.
        bool serverAck = receiveTimeout(THREAD_TIMEOUT_DUR, (string packet, immutable long recvLen) {
            if (recvLen > 0)
            {
                Tuple!(string, int, bool) usernameId = decodeUserConnPacket(packet, recvLen);
                string uname = usernameId[0];
                int cid = usernameId[1];
                ApplicationState.setUsername(uname);
                ApplicationState.setClientId(cid);
                ApplicationState.addConnectedUser(uname, cid);
            }
        });

        // Shutdown our thread if we are not able to connect to the server.
        if (serverAck)
        {
            connectionStatus = true;
        }
    }

    /**
     * Sends a message to the child thread to shutdown and marks our thread as closed.
     */
    void shutdown()
    {
        immutable bool shutdown = true;
        send(this.childThread, shutdown);
        threadActive = false;
    }

    /**
     * Sends the given message to the child thread.
     *
     * Params:
     *       - message : string : message to send
     */
    void sendToChild(string message)
    {
        send(this.childThread, message);
    }

public:
    /**
     * Gets the current Communicator object.
     *
     * Params:
     *       - port     : ushort : the port to connect to
     *       - ip       : string : the ip to connect to
     *       - username : string : the username to connect with
     * Returns:
     *       - communicator : Communicator : a communicator object
     */
    static Communicator getCommunicator(ushort port = 0, string ip = "-1", string username = "-1")
    {
        if (instance is null)
        {
            writeln("attempting to get a new communicator");
            instance = new Communicator(port, ip, username);
            if (!Communicator.getConnectionStatus())
            {
                Communicator.disconnect();
            }
        }
        return instance;
    }

    /**
    * Sends a connection packet to the server.
    *
    * Params:
    *       - username : string : the username to disconnect with
    */
    static void sendDisconnectPacket(string username)
    {
        int clientId = ApplicationState.getClientId();
        // Create connection packet (disconnected -- false) and send it to the server.
        string connReqPacket = encodeUserConnPacket(username, clientId, false);
        send(childThread, connReqPacket);
    }

    /**
     * Shuts down our networking thread if one exists.
     */
    static void disconnect()
    {
        if (!(instance is null))
        {
            instance.shutdown();
            instance = null;
        }
    }

    /**
     * Sends a message to our child thread if one exists.
     *
     * Params:
     *       - message : string : the message to send
     */
    static void queueMessageSend(string message)
    {
        if (!(instance is null))
        {
            instance.sendToChild(message);
        }
    }

    /**
     * Receives all waiting messages from the child thread if there is one and returns them.
     *
     * Returns:
     *        - messages : Tuple!(string, long)[] : an array of received messages and their lengths
     */
    static Tuple!(string, long)[] receiveNetworkMessages()
    {
        Tuple!(string, long)[] packetsToHandle = [];
        if (!(instance is null))
        {
            for (bool messageReceived = true; messageReceived;)
            {
                messageReceived = receiveTimeout(TIMEOUT_DUR, (string message, immutable long recv) {
                    long recvLen = recv;
                    auto messageAndLen = tuple(message, recvLen);
                    packetsToHandle ~= messageAndLen;
                }, (bool closedSocket) { Communicator.disconnect(); });
            }
        }
        return packetsToHandle;
    }

    /**
     * Gets the status of the child thread.
     *
     * Returns:
     *        - threadStatus : bool : a boolean representing whether or not the internal thread is active
     */
    static bool getThreadStatus()
    {
        return threadActive;
    }

    /**
     * Gets the status of the connection.
     *
     * Returns:
     *        - connStatus : bool : a boolean representing whether or not we are connected
     */
    static bool getConnectionStatus()
    {
        return connectionStatus;
    }
}

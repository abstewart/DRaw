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

/**
 * Class intended to represent a communication object between the main and network thread.
 */
class Communicator
{
private:
    static final threadTimeoutDuration = 3.secs;
    static bool threadActive = false;
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
        // spawn thread and wait for connection 
        threadActive = true;
        childThread = spawn(&handleNetworking, thisTid, ip, port);
        int clientId = ApplicationState.getClientId();
        string connReqPacket = encodeUserConnPacket(username, clientId);
        send(childThread, connReqPacket);

        // receive an acknowledgement packet from the server and update the application state
        bool serverAck = receiveTimeout(threadTimeoutDuration, (string packet, immutable long recvLen) {
            if (recvLen > 0)
            {
                Tuple!(string, int) usernameId = decodeUserConnPacket(packet, recvLen);
                string uname = usernameId[0];
                int cid = usernameId[1];
                ApplicationState.setUsername(uname);
                ApplicationState.setClientId(cid);
                ApplicationState.addConnectedUser(uname, cid);
                writeln("user ", username, " with client id ", clientId, " has been acknowledged");
            }
        });

        // shutdown our thread if we are not able to connect to the server
        if (!serverAck) {
            shutdown();
        }
    }

    void shutdown()
    {
        immutable bool shutdown = true;
        send(this.childThread, shutdown);
        threadActive = false;
    }

    void sendToChild(string message)
    {
        send(childThread, message);
    }

public:
    static Communicator getCommunicator(ushort port = 0, string ip = "-1", string username = "-1")
    {
        if (instance is null)
        {
            instance = new Communicator(port, ip, username);
        }
        return instance;
    }

    static void disconnect()
    {
        if (!(instance is null))
        {
            instance.shutdown();
            instance = null;
        }
    }

    static void queueMessageSend(string message)
    {
        if (!(instance is null))
        {
            writeln(message);
            instance.sendToChild(message);
        }
    }

    static Tuple!(string, long)[] receiveNetworkMessages()
    {
        Tuple!(string,long)[] packetsToHandle = [];
        if (!(instance is null))
        {
            for (bool messageReceived = true; messageReceived;)
            {
                messageReceived = receiveTimeout(TIMEOUT_DUR, (string message, immutable long recv) {
                    auto messageAndLen = tuple(message, recv);
                    packetsToHandle ~= messageAndLen;         
                }, 
                (bool closedSocket) { Communicator.disconnect(); });
            }
        }
        return packetsToHandle;
    }
}

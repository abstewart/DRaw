module model.Communicator;

import std.concurrency;

import std.stdio : writeln;
import std.typecons;

import model.network.thread_entry;
import controller.commands.Command;
import model.packets.packet;

class Communicator {
    
    private:
        static bool threadActive = false;
        static Tid childThread;
        static int clientId;
        static string username;
        static string[int] connectedUsers;
        static Tuple!(string, int, char[255])[] chatHistory;
        static Communicator instance = null;

        this(ushort port, string ip, string username) {
            threadActive = true;
            clientId = -1;
            childThread = spawn(&handleNetworking, thisTid, ip, port);
            string connReqPacket = encodeUserConnPacket(username, clientId);
            writeln(connReqPacket);
            send(childThread, connReqPacket);
            receive(
                (string packet, immutable long recvLen) {
                    if (recvLen > 0) {
                        Tuple!(string, int) usernameId = decodeUserConnPacket(packet, recvLen);
                        username = usernameId[0];
                        clientId = usernameId[1];
                        connectedUsers[clientId] = username;
                        writeln("user ", username, " with client id ", clientId, " has been acknowledged");
                    }
                }
            );


        }

        ~this() {

        }

    public:
        static Communicator getCommunicator(ushort port, string ip, string username) {
            if (instance is null) {
                instance = new Communicator(port, ip, username);
            } 
            return instance;
        }

        static void disconnect() {
            if (!(instance is null)) {
                immutable bool shutdown = true;
                send(childThread, shutdown);
                instance = null;
                string[int] emptyConnTable;
                connectedUsers = emptyConnTable;
            }
        }

        static void queueMessageSend(string message) {
            if (!(instance is null)) {
                immutable bool sendData = true;
                send(childThread, sendData, message);
            }
        }

        static void receiveNetworkMessages(ref Command[] commandStack) {
            if (!(instance is null)) {
                for( bool messageReceived = true; messageReceived; ) {
                    messageReceived = receiveTimeout(TIMEOUT_DUR,
                        (string commandEnc, immutable long recv) {
                            // Command command = Packet.dispatchDecoder(messageReceived);
                            // commandStack ~= [command];
                        },
                        (bool closedSocket) {
                            instance = null;
                        }
                    );
                }
            }
        }

        static int getClientId() {
            return clientId;
        }

        static addConnectedUser(string username, int id) {
            connectedUsers[id] = username;
        }

        static removeConnectedUser(int id) {
            connectedUsers.remove(id);
        }
}
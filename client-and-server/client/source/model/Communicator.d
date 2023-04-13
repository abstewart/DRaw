module model.Communicator;

import std.concurrency;

import std.stdio : writeln;
import std.typecons;
import std.algorithm;

import model.network.thread_entry;
import controller.commands.Command;
import model.packets.packet;

class Communicator {
    
    private:
        static bool threadActive = false;
        static Tid childThread;
        int clientId = -1;
        string username = "";
        string[int] connectedUsers;
        static Tuple!(string, int, char[255])[] chatHistory;
        static int curCmd = 0;
        static Communicator instance = null;

        this(ushort port, string ip, string username) {
            threadActive = true;
            childThread = spawn(&handleNetworking, thisTid, ip, port);
            string connReqPacket = encodeUserConnPacket(username, clientId);
            send(childThread, connReqPacket);
            receive(
                (string packet, immutable long recvLen) {
                    if (recvLen > 0) {
                        Tuple!(string, int) usernameId = decodeUserConnPacket(packet, recvLen);
                        this.username = usernameId[0];
                        this.clientId = usernameId[1];
                        this.connectedUsers[clientId] = username;
                        writeln("user ", username, " with client id ", clientId, " has been acknowledged");
                    }
                }
            );
        }

        ~this() {

        }

        int getCid() {
            return this.clientId;
        }

        string getUname() {
            return this.username;
        }

        void addConnectedUser(string username, int id) {
            this.connectedUsers[id] = username;
        }

        void removeConnectedUser(int id) {
            this.connectedUsers.remove(id);
        }

        void shutdown() {
            immutable bool shutdown = true;
            send(this.childThread, shutdown);
        }

        void sendToChild(string message) {
            send(this.childThread, message);
        }

    public:
        static Communicator getCommunicator(ushort port = 0, string ip = "-1", string username = "-1") {
            if (instance is null) {
                instance = new Communicator(port, ip, username);
                writeln("instanace has been set");
            } 
            return instance;
        }

        static void disconnect() {
            if (!(instance is null)) {
                instance.shutdown();
                instance = null;
            }
        }

        static void queueMessageSend(string message) {
            if (!(instance is null)) {
                writeln(message);
                instance.sendToChild(message);
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
            if (!(instance is null)) {
                return instance.getCid();
            }
            return -1;
        }

        static string getUsername() {
            if (!(instance is null)) {
                return instance.getUname();
            }
            return "";
        }

        static void addUser(string username, int id) {
            if (!(instance is null)) {
                instance.addConnectedUser(username, id);
            }
        }

        static void removeUser(int id) {
            if (!(instance is null)) {
                instance.removeConnectedUser(id);
            }
        }

        static int getCurCommandId() {
            return curCmd;
        }

        static void nextCommand() {
            curCmd += 1;
        }
}
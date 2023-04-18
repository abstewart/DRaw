module model.packets.packet;

import std.conv : to;
import std.format : format;
import std.array : split;
import std.stdio : writeln;
import std.algorithm : equal;
import std.string;
import std.typecons;
import gdk.RGBA;

import controller.commands.Command;
import controller.commands.CommandBuilder;
import model.Communicator;
import model.ApplicationState;
import view.MyWindow;

immutable int USER_CONNECT_PACKET = 0; // Packet type for a user connection packet.
immutable int DRAW_COMMAND_PACKET = 1; // Packet type for a draw command packet.
immutable int UNDO_COMMAND_PACKET = 2; // Packet type for an undo command packet.
immutable int CHAT_MESSAGE_PACKET = 3; // Packet type for a chat message packet.
immutable char END_MESSAGE = '\r'; // End packet delimiter.

/**
 * Parses and executes any packets that have come in from the server.
 */
bool resolveRemotePackets(MyWindow window)
{
    Tuple!(string, long)[] packetsToResolve = Communicator.receiveNetworkMessages();
    foreach (Tuple!(string, long) packet; packetsToResolve)
    {
        char packetOld = packet[0][0];
        immutable int packetType = to!int(packet[0][0]) - '0';
        switch (packetType)
        {
        case (USER_CONNECT_PACKET):
            parseAndExecuteUserConnPacket(packet[0], packet[1], window);
            break;
        case (DRAW_COMMAND_PACKET):
            parseAndExecuteUserDrawPacket(packet[0], packet[1], window);
            break;
        case (CHAT_MESSAGE_PACKET):
            parseAndExecuteChatMessage(packet[0], packet[1], window);
            break;
        case (UNDO_COMMAND_PACKET):
            parseAndExecuteUndoCommand(packet[0], packet[1], window);
            break;
        default:
            writeln("no case found");
            break;
        }
    }
    return true;
}

/**
 * Parses and executes user connection status packets. If it is a user connection packet, 
 * adds user to connected users. If a disconnection packet, removes users from connected users.
 *
 * Params: 
 *        - packet : string : packet to decode
 *        - recv   : long : length in bytes of received message
 */
void parseAndExecuteUserConnPacket(string packet, long recv, MyWindow window)
{
    Tuple!(string, int, bool) info = decodeUserConnPacket(packet, recv);
    if (info[2])
    {
        ApplicationState.addConnectedUser(info[0], info[1]);

        window.getChatBox().getMyChatBox().userConnectionUpdate(info[0], info[1], info[2]);
    }
    else
    {
        window.getChatBox().getMyChatBox().userConnectionUpdate(info[0], info[1], info[2]);
        ApplicationState.removeConnectedUser(info[1]);
    }
}

/**
 * Decodes a user connection packet into a tuple of username, user id, and connection status.
 * Intended packet format:
 *          0,username,id,c/d\r
 *         [0,1       ,2 ,3   ] 
 *
 * Params: 
 *        - packet : string : packet to decode
 *        - recv   : long : length in bytes of received message
 * 
 * Returns: 
 *        - a tuple of username, user id, connection status : Tuple!(string, int, bool)
 */
Tuple!(string, int, bool) decodeUserConnPacket(string packet, long recv)
{
    string raw = packet[0 .. packet.indexOf(END_MESSAGE)];
    auto fields = raw.split(',');
    int b = to!int(fields[3]);
    return tuple(fields[1], to!int(fields[2]), to!bool(b));
}

/**
* Testing the decodeUserConnPacket() method.
*/
@("Testing decodeUserConnPacket")
unittest
{
    string testPacket = "0,User,1,1\r";
    long lengthOfBytes = 11;
    Tuple!(string, int, bool) connectionPacket = decodeUserConnPacket(testPacket, lengthOfBytes);

    import std.algorithm.comparison : equal;

    assert(connectionPacket[0].equal("User"));
    assert(connectionPacket[1] == 1);
    assert(connectionPacket[2]);
}

/**
 * Encodes a user connection packet into a string given username, id, and status.
 * Intended packet format:
 *          0,username,id,c/d\r
 *         [0,1       ,2 ,3   ] 
 *
 * Params: 
 *        - username   : string : username to encode
 *        - id         : int : user id to encode
 *        - connStatus : bool : desired connection operation
 *
 * Returns: 
 *        - a user connection packet : string
 */
string encodeUserConnPacket(string username, int id, bool connStatus)
{
    string packet = "%s,%s,%s,%s\r".format(USER_CONNECT_PACKET, username,
            to!string(id), to!string(to!int(connStatus)));
    return packet;
}

/**
* Testing the encodeUserConnPacket() method.
*/
@("Testing encodeUserConnPacket")
unittest
{
    string testUsername = "User";
    int testId = 5;
    bool testConnectionStatus = false;

    string testPacket = encodeUserConnPacket(testUsername, testId, testConnectionStatus);
    import std.algorithm.comparison : equal;

    assert(testPacket.equal("0,User,5,0\r"));
}

/**
 * Parses and executes user draw packets. 
 *
 * Params: 
 *        - packet : string : packet to decode
 *        - recv   : long : length in bytes of received message
 */
void parseAndExecuteUserDrawPacket(string packet, long recv, MyWindow window)
{
    Tuple!(string, int, Command) userIdCmd = decodeUserDrawCommand(packet, recv, window);
    ApplicationState.addToCommandHistory(userIdCmd);
}

/**
 * Decodes a user draw packet into a tuple of username, user id, and command.
 * Intended packet format:
 *          1,username,id,cmdId,brushType,brushSize,x,y,color\r
 *         [0,1       ,2 ,3    ,4        ,5        ,6,7,8    ]
 *
 * Params: 
 *        - packet : string : packet to decode
 *        - recv   : long : length in bytes of received message
 * 
 * Returns: 
 *        - a tuple of username, user id, Command : Tuple!(string, int, Command)
 */
Tuple!(string, int, Command) decodeUserDrawCommand(string packet, long recv, MyWindow window)
{
    string raw = packet[0 .. packet.indexOf(END_MESSAGE)];
    auto fields = raw.split(',');
    string username = to!string(fields[1]);
    int uid = to!int(fields[2]);
    Command cmd = commandMux(to!int(fields[3]), to!int(fields[4]),
            to!int(fields[5]), to!int(fields[6]), to!int(fields[7]), fields[8], window);

    return tuple(username, uid, cmd);
}

/**
 * Encodes a user draw packet into a string given username, id, and command.
 * Intended packet format:
 *          0,username,id,c/d\r
 *         [0,1       ,2 ,3   ] 
 *
 * Params: 
 *        - username : string : username to encode
 *        - id       : int : user id to encode
 *        - toEncode : Command : command object to encode
 *
 * Returns: 
 *        - a user draw packet : string
 */
string encodeUserDrawCommand(string username, int id, Command toEncode)
{
    string packet = "%s,%s,%s,%s\r".format(DRAW_COMMAND_PACKET, username, id, toEncode.encode());
    return packet;
}

/**
 * Parses and executes undo packets. Undos all commands that have the parsed username and the parsed command type.
 *
 * Params: 
 *        - packet : string : packet to decode
 *        - recv   : long : length in bytes of received message
 */
void parseAndExecuteUndoCommand(string packet, long recv, MyWindow window)
{
    Tuple!(string, int, int) userIdCid = decodeUndoCommandPacket(packet, recv);
    string usernameToUndo = userIdCid[0];
    int idToUndo = userIdCid[1];
    int cidToUndo = userIdCid[2];
    Tuple!(string, int, Command)[] validCmds = [];
    foreach (Tuple!(string, int, Command) uIdCmd; ApplicationState.getCommandHistory())
    {
        string user = uIdCmd[0];
        int id = uIdCmd[1];
        Command cmd = uIdCmd[2];
        int cid = cmd.getCmdId();
        if (usernameToUndo.equal(user) && idToUndo == id && cidToUndo == cid)
        {
            cmd.undo();
            continue;
        }
        validCmds ~= uIdCmd;
    }
    ApplicationState.setCommandHistory(validCmds);
}

/**
 * Decodes an undo packet into a tuple of username, user id, and command id.
 * Intended packet format:
 *          2,username,id,cid\r
 *         [0,1       ,2 ,3   ] 
 *
 * Params: 
 *        - packet : string : packet to decode
 *        - recv   : long : length in bytes of received message
 * 
 * Returns: 
 *        - a tuple of username, user id, command id : Tuple!(string, int, in)
 */
Tuple!(string, int, int) decodeUndoCommandPacket(string packet, long recv)
{
    string raw = packet[0 .. packet.indexOf(END_MESSAGE)];
    auto fields = raw.split(',');
    string username = to!string(fields[1]);
    int uid = to!int(fields[2]);
    int cid = to!int(fields[3]);
    return tuple(username, uid, cid);
}

/**
* Testing the decodeUndoCommandPacket() method.
*/
@("Testing decodeUndoCommandPacket")
unittest
{
    string testPacket = "2,Bob,2,0\r";
    long lengthOfBytes = 10;
    Tuple!(string, int, int) undoCommandPacket = decodeUndoCommandPacket(testPacket, lengthOfBytes);

    import std.algorithm.comparison : equal;

    assert(undoCommandPacket[0].equal("Bob"));
    assert(undoCommandPacket[1] == 2);
    assert(undoCommandPacket[2] == 0);
}

/**
 * Encodes an undo command packetinto a string given username, id, and command id.
 * Intended packet format:
 *          2,username,id,cid\r
 *         [0,1       ,2 ,3   ] 
 *
 * Params: 
 *        - username : string : username to encode
 *        - id       : int : user id to encode
 *        - cid      : int : command id to encode
 *
 * Returns: 
 *        - an undo command packet : string
 */
string encodeUndoCommandPacket(string username, int uid, int cid)
{
    string packet = "%s,%s,%s,%s\r".format(UNDO_COMMAND_PACKET, username, uid, cid);
    return packet;
}

/**
* Testing the encodeUndoCommandPacket() method.
*/
@("Testing encodeUndoCommandPacket")
unittest
{
    string testUsername = "User";
    int testUId = 3;
    int testCId = 2;

    string testPacket = encodeUndoCommandPacket(testUsername, testUId, testCId);
    import std.algorithm.comparison : equal;

    assert(testPacket.equal("2,User,3,2\r"));
}

/**
 * Parses and executes chat packets. Adds the parsed chat message to the chat history.
 *
 * Params: 
 *        - packet : string : packet to decode
 *        - recv   : long : length in bytes of received message
 */
void parseAndExecuteChatMessage(string packet, long recv, MyWindow window)
{
    Tuple!(string, int, long, string) userIdTimeMsg = decodeChatPacket(packet, recv);
    window.getChatBox().getMyChatBox().updateMessageWindow(userIdTimeMsg[0],
            userIdTimeMsg[1], userIdTimeMsg[2], userIdTimeMsg[3]);
}

/**
 * Decodes a chat packet into a tuple of username, user id, timestamp and message.
 * Intended packet format:
 *          3,username,id,timestamp,message\r
 *         [0,1       ,2 ,3        ,4     ]
 *
 * Params: 
 *        - packet : string : packet to decode
 *        - recv   : long : length in bytes of received message
 * 
 * Returns: 
 *        - a tuple of username, user id, timestamp, message: Tuple!(string, int, long, string)
 */
Tuple!(string, int, long, string) decodeChatPacket(string packet, long recv)
{
    string raw = packet[0 .. packet.indexOf(END_MESSAGE)];
    auto fields = raw.split(',');
    string username = to!string(fields[1]);
    int uid = to!int(fields[2]);
    long time = to!long(fields[3]);
    string msg = to!string(fields[4]);
    return tuple(username, uid, time, msg);
}

/**
* Testing the decodeChatPacket() method.
*/
@("Testing decodeChatPacket")
unittest
{
    string testPacket = "3,User,2,125,This is a test message.\r";
    long lengthOfBytes = 37;
    Tuple!(string, int, long, string) chatPacket = decodeChatPacket(testPacket, lengthOfBytes);

    import std.algorithm.comparison : equal;

    assert(chatPacket[0].equal("User"));
    assert(chatPacket[1] == 2);
    assert(chatPacket[2] == 125);
    assert(chatPacket[3].equal("This is a test message."));
}

/**
 * Encodes a chat packet into a string given username, id, timestamp, and message.
 * Intended packet format:
 *          3,username,id,timestamp,message\r
 *         [0,1       ,2 ,3        ,4      ]
 *
 * Params: 
 *        - username  : string : username to encode
 *        - id        : int : user id to encode
 *        - timestamp : long : time stamp of message
 *        - message   : string : message to encode
 *
 * Returns: 
 *        - a chat packet : string
 */
string encodeChatPacket(string username, int id, long timestamp, string message)
{
    string packet = "%s,%s,%s,%s,%s\r".format(CHAT_MESSAGE_PACKET, username,
            id, timestamp, message);
    return packet;
}

/**
* Testing the encodeChatPacket() method.
*/
@("Testing encodeChatPacket")
unittest
{
    string testUsername = "User";
    int testId = 2;
    long testTimeStamp = 125;
    string testMessage = "This is a test message.";

    string testChatPacket = encodeChatPacket(testUsername, testId, testTimeStamp, testMessage);
    import std.algorithm.comparison : equal;

    assert(testChatPacket.equal("3,User,2,125,This is a test message.\r"));
}

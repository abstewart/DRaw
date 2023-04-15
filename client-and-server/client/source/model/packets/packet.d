module model.packets.packet;

import std.conv : to;
import std.format : format;
import std.array : split;
import std.stdio : writeln;
import std.string;
import std.typecons;
import gdk.RGBA;

import controller.commands.Command;
import controller.commands.CommandBuilder;
import model.Communicator;
import model.ApplicationState;

immutable int USER_CONNECT_PACKET = 0; // packet type for a user connection packet
immutable int DRAW_COMMAND_PACKET = 1; // packet type for a draw command packet
immutable int UNDO_COMMAND_PACKET = 2; // packet type for an undo command packet
immutable int CHAT_MESSAGE_PACKET = 3; // packet type for a chat message packet
immutable int CANVAS_SYNCH_PACKET = 4; // packet type for a canvas sync packet
immutable char END_MESSAGE = '\r';     // end packet delimiter

/**
 * Parses and executes any packets that have come in from the server.
 */
void resolveRemotePackets() {
    Tuple!(string, long)[] packetsToResolve = Communicator.receiveNetworkMessages();
    foreach(Tuple!(string, long) packet ; packetsToResolve) {
        char packetType = packet[0][0];
        switch (to!int(packetType)) {
            case (USER_CONNECT_PACKET):
                parseAndExecuteUserConnPacket(packet[0], packet[1]);
                break;
            case (DRAW_COMMAND_PACKET):
                parseAndExecuteUserDrawPacket(packet[0], packet[1]);
                break;
            case (CHAT_MESSAGE_PACKET):
                parseAndExecuteChatMessage(packet[0], packet[1]);
                break;
            case (UNDO_COMMAND_PACKET):
                parseAndExecuteUndoCommand(packet[0], packet[1]);
                break;
            case (CANVAS_SYNCH_PACKET):
            //  &decodeCanvasSyncPacket;
                break;
            default:
                break;
        }
    }
}

/**
 * Parses and executes user connection status packets. If it is a user connection packet, 
 * adds user to connected users. If a disconnection packet, removes users from connected users.
 *
 * Params: 
 *        - packet : string : packet to decode
 *        - recv   : long : length in bytes of received message
 */
void parseAndExecuteUserConnPacket(string packet, long recv) {
    Tuple!(string, int, bool) info = decodeUserConnPacket(packet, recv);
    if (info[2]) {
        ApplicationState.addConnectedUser(info[0], info[1]);
    } else {
        ApplicationState.removeConnectedUser(info[1]);
    }
}

/**
 * Decodes a user connection packet into a tuple of username, user id, and connection status
 * Intended packet format:
 *          0,username,id,c/d\r
 *         [0,1       ,2 ,3   ] 
 *
 * Params: 
 *        - packet : string : packet to decode
 *        - recv   : long : length in bytes of received message
 * 
 * Returns: 
 *        - a tuple of username, user id, connection status : Tuple!(string, int, bool) :
 */
Tuple!(string, int, bool) decodeUserConnPacket(string packet, long recv)
{
    auto fields = packet[0 .. recv - 1].split(',');
    return tuple(fields[1], to!int(fields[2]), to!bool(fields[3]));
}

/**
 * Encodes a user connection packet into a string given username, id, and status
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
 *        - a user connection packet : string :
 */
string encodeUserConnPacket(string username, int id, bool connStatus)
{
    string packet = "%s,%s,%s,%s\r".format(USER_CONNECT_PACKET, username, to!string(id), to!string(connStatus));
    return packet;
}

/**
 * Parses and executes user draw packets. 
 *
 * Params: 
 *        - packet : string : packet to decode
 *        - recv   : long : length in bytes of received message
 */
void parseAndExecuteUserDrawPacket(string packet, long recv) {
    Tuple!(string, int, Command) info = decodeUserDrawCommand(packet, recv);
    // TODO: submit command to drawing window and command history
}

/**
 * Decodes a user draw packet into a tuple of username, user id, and command
 * Intended packet format:
 *          1,username,id,cmdId,brushType,brushSize,x,y,color\r
 *         [0,1       ,2 ,3    ,4        ,5        ,6,7,8    ]
 *
 * Params: 
 *        - packet : string : packet to decode
 *        - recv   : long : length in bytes of received message
 * 
 * Returns: 
 *        - a tuple of username, user id, Command : Tuple!(string, int, Command) :
 */
Tuple!(string, int, Command) decodeUserDrawCommand(string packet, long recv)
{
    auto fields = packet[0 .. recv - 1].split(',');
    writeln(fields);
    string username = to!string(fields[1]);
    int uid = to!int(fields[2]);
    Command cmd = commandMux(to!int(fields[3]), to!int(fields[4]),
            to!int(fields[5]), to!int(fields[6]), to!int(fields[7]), fields[8]);

    return tuple(username, uid, cmd);
}

/**
 * Encodes a user draw packet into a string given username, id, and command
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
 *        - a user draw packet : string :
 */
string encodeUserDrawCommand(string username, int id, Command toEncode)
{
    string packet = "%s,%s,%s,%s\r".format(DRAW_COMMAND_PACKET, username, id, toEncode.encode());
    return packet;
}

/**
 * Parses and executes undo packets. Undos all commands that have the parsed username and the parsed command type
 *
 * Params: 
 *        - packet : string : packet to decode
 *        - recv   : long : length in bytes of received message
 */
void parseAndExecuteUndoCommand(string packet, long recv) {
    Tuple!(string, int, int) userIdCid = decodeUndoCommandPacket(packet, recv);
    // TODO: iterate though the command history and undo any command with id == cid
}

/**
 * Decodes an undo packet into a tuple of username, user id, and command id
 * Intended packet format:
 *          2,username,id,cid\r
 *         [0,1       ,2 ,3   ] 
 *
 * Params: 
 *        - packet : string : packet to decode
 *        - recv   : long : length in bytes of received message
 * 
 * Returns: 
 *        - a tuple of username, user id, command id : Tuple!(string, int, in) :
 */
Tuple!(string, int, int) decodeUndoCommandPacket(string packet, long recv)
{
    auto fields = packet[0 .. recv - 1].split(',');
    string username = to!string(fields[1]);
    int uid = to!int(fields[2]);
    int cid = to!int(fields[3]);
    return tuple(username, uid, cid);
}

/**
 * Encodes an undo command packetinto a string given username, id, and command id
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
 *        - an undo command packet : string :
 */
string encodeUndoCommandPacket(string username, int uid, int cid)
{
    string packet = "%s,%s,%s,%s\r".format(UNDO_COMMAND_PACKET, username, uid, cid);
    return packet;
}

/**
 * Parses and executes chat packets. Adds the parsed chat message to the chat history.
 *
 * Params: 
 *        - packet : string : packet to decode
 *        - recv   : long : length in bytes of received message
 */
void parseAndExecuteChatMessage(string packet, long recv) {
    Tuple!(string, int, long, string) userIdTimeMsg = decodeChatPacket(packet, recv);
    // TODO: add message into the chat queue
}

/**
 * Decodes a chat packet into a tuple of username, user id, timestamp and message
 * Intended packet format:
 *          3,username,id,timestamp,message\r
 *         [0,1       ,2 ,3        ,4     ]
 *
 * Params: 
 *        - packet : string : packet to decode
 *        - recv   : long : length in bytes of received message
 * 
 * Returns: 
 *        - a tuple of username, user id, timestamp, message: Tuple!(string, int, long, string) :
 */
Tuple!(string, int, long, string) decodeChatPacket(string packet, long recv)
{
    auto fields = packet[0 .. recv - 1].split(',');
    string username = to!string(fields[1]);
    int uid = to!int(fields[2]);
    long time = to!long(fields[3]);
    string msg = to!string(fields[4]);
    return tuple(username, uid, time, msg);
}

/**
 * Encodes a chat packet into a string given username, id, timestamp, and message
 * Intended packet format:
 *          3,username,id,timestamp,message\r
 *         [0,1       ,2 ,3        ,4      ]
 *
 * Params: 
 *        - username  : string : username to encode
 *        - id        : int : user id to encode
 *        - timestamp : bool : desired connection operation
 *        - message   : string : message to encode
 *
 * Returns: 
 *        - a chat packet : string :
 */
string encodeChatPacket(string username, int id, long timestamp, string message)
{
    string packet = "%s,%s,%s,%s,%s\r".format(CHAT_MESSAGE_PACKET, username,
            id, timestamp, message);
    return packet;
}



// TODO: FIGURE OUT CANVAS SYNC behavior
// void parseAndExecuteCanvasSync(string packet, long recv) {
//     Tuple!(Canvas) canv = decodeCanvasSyncPacket(packet, recv);
//     //TODO update canvase
// }
// Tuple!(Canvas) decodeCanvasSyncPacket(string packet, long recv) {

// }
// string encodeCanvasSyncPacket(Canvas canvas) {

// }


module model.packets.packet;

import std.conv : to;
import std.format : format;
import std.array : split;
import std.stdio : writeln;
import std.string;
import std.typecons;
import gdk.RGBA;

import controller.commands.Command;
import controller.commands.DrawPointCommand;
import model.packets.packet_key;

immutable char END_MESSAGE = '\r';

/// provides a general packet decoder that returns the function to use on a packet to decode it.
void* getPacketDecoder(string packet)
{
    char packetType = packet[0];
    switch (to!int(packetType))
    {
    case (USER_CONNECT_PACKET):
        return &decodeUserConnPacket;
    case (DRAW_COMMAND_PACKET):
        return &decodeUserDrawCommand;
    default:
        return &decodeUserConnPacket;
    }
}

void* getPacketEncoder(int packetType)
{
    switch (packetType)
    {
    case (USER_CONNECT_PACKET):
        return &encodeUserConnPacket;
    case (DRAW_COMMAND_PACKET):
        return &encodeUserDrawCommand;
    default:
        return &decodeUserConnPacket;
    }
}

/// FORMAT:  0,username,id\r
/// FIELDS: [0,1       ,2]
Tuple!(string, int) decodeUserConnPacket(string packet, long recv)
{
    auto fields = packet[0 .. recv - 1].split(',');
    return tuple(fields[1], to!int(fields[2]));
}

/// FORMAT:  0,username,id\r
/// FIELDS: [0,1       ,2]
string encodeUserConnPacket(string username, int id)
{
    string packet = "%s,%s,%s\r".format(USER_CONNECT_PACKET, username, to!string(id));
    return packet;
}

/// FORMAT:  1,username,id,cmdId,brushType,brushSize,x,y,color\r
/// FIELDS: [0,1       ,2 ,3    ,4        ,5        ,6,7,8   ]
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

/// FORMAT:  1,username,id,cmdId,brushType,brushSize,x,y,color\r
/// FIELDS: [0,1       ,2 ,3    ,4        ,5        ,6,7,8   ]
string encodeUserDrawCommand(string username, int id, Command toEncode)
{
    string packet = "%s,%s,%s,%s\r".format(DRAW_COMMAND_PACKET, username, id, toEncode.encode());
    return packet;
}

/// FORMAT:  2,username,id,cid\r
/// FIELDS: [0,1       ,2 ,3 ]
Tuple!(string, int, int) decodeUndoCommandPacket(string packet, long recv)
{
    auto fields = packet[0 .. recv - 1].split(',');
    string username = to!string(fields[1]);
    int uid = to!int(fields[2]);
    int cid = to!int(fields[3]);
    return tuple(username, uid, cid);
}

/// FORMAT:  2,username,id,cid\r
/// FIELDS: [0,1       ,2 ,3  ]
string encodeUndoCommandPacket(string username, int uid, int cid)
{
    string packet = "%s,%s,%s,%s\r".format(UNDO_COMMAND_PACKET, username, uid, cid);
    return packet;
}

/// FORMAT:  3,username,id,timestamp,message\r
/// FIELDS: [0,1       ,2 ,3        ,4     ]
Tuple!(string, int, long, string) decodeChatPacket(string packet, long recv)
{
    auto fields = packet[0 .. recv - 1].split(',');
    string username = to!string(fields[1]);
    int uid = to!int(fields[2]);
    long time = to!long(fields[3]);
    string msg = to!string(fields[4]);
    return tuple(username, uid, time, msg);
}

/// FORMAT:  3,username,id,timestamp,message\r
/// FIELDS: [0,1       ,2 ,3        ,4      ]
string encodeChatPacket(string username, int id, long timestamp, string message)
{
    string packet = "%s,%s,%s,%s,%s\r".format(CHAT_MESSAGE_PACKET, username,
            id, timestamp, message);
    return packet;
}

// TODO: FIGURE OUT CANVAS SYNC PACKET
// Tuple!(Canvas) decodeCanvasSyncPacket(string packet, long recv) {

// }
// string encodeCanvasSyncPacket(Canvas canvas) {

// }

Command commandMux(int cId, int cType, int cWidth, int x, int y, string color)
{
    auto col = color.split('|');
    writeln(col);
    RGBA cmdColor = new RGBA(to!int(col[0]), to!int(col[1]), to!int(col[2]), to!int(col[3]));
    return new DrawPointCommand(100, 100, cmdColor, 5, new MyDrawing(), cId);
}
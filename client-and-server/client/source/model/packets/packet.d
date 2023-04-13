module model.packets.packet;

import std.conv : to;
import std.format : format;
import std.array : split;
import std.stdio : writeln;
import std.string;
import std.typecons;

import controller.commands.Command;
import model.packets.packet_key;

immutable char END_MESSAGE = '\r';

/// provides a general packet dispatcher that decodes a given packet and executes the action associated with it
/// the general packet structure is as follows:
/// 1 BYTE PACKET ID 
/// 1 BYTE USER ID
/// N BYTES DATA
void* getPacketDecoder(string packet) {
    char packetType = packet[0];
    switch(to!int(packetType)) {
        case(USER_CONNECT_PACKET):
            return &decodeUserConnPacket;
        default:
            return &decodeUserConnPacket;
    }
}

/// FORMAT:  0,username,id\r
/// FIELDS: [0,1       ,2]
Tuple!(string,int) decodeUserConnPacket(string packet, long recv) {
    auto fields = packet[0 .. recv - 1].split(',');
    return tuple(fields[1], to!int(fields[2]));
}

/// FORMAT:  0,username,id\r
/// FIELDS: [0,1       ,2]
string encodeUserConnPacket(string username, int id) {
    string packet = "%s,%s,%s\r".format(USER_CONNECT_PACKET, username, to!string(id));
    return packet;
}

/// FORMAT:  1,username,cmdId,id,brushType,brushSize,x,y,color\r
/// FIELDS: [0,1       ,2    ,3 ,4        ,5        ,6,7,8   ]
Tuple!(string,int,Command) decodeUserDrawCommand(string packet, long recv) {
    auto fields = packet[0 .. recv - 1].split(',');
    return tuple(fields[1], fields[2], commandMux(fields[3], fields[4], fields[5], fields[6]))
}

/// FORMAT:  1,username,cmdId,id,brushType,brushSize,x,y,color\r
/// FIELDS: [0,1       ,2    ,3 ,4        ,5        ,6,7,8   ]
string encodeUserDrawCommand(string username, int id, Command toEncode) {

}
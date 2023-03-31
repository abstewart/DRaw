module encode_decode;

import std.conv;
import std.stdio;
import std.format;
import std.array;

import command_enum;
import draw_pixel_command;
import command;
import color : Color;

int SKIP_VALUE = -1;

char[] encodeCommand(int commandType, int brushSize, Color color, int xPos, int yPos) {
    char[] encoded = [];
    string cmdType = (commandType == SKIP_VALUE) ? "" : to!string(commandType);
    string brush = (brushSize == SKIP_VALUE) ? "" : to!string(brushSize);
    string col = !color.isValidColor() ? "" : color.toEncodedString();
    string x = (xPos == SKIP_VALUE) ? "" : to!string(xPos);
    string y = (yPos == SKIP_VALUE) ? "" : to!string(yPos);
    encoded ~= format("%s,%s,%s,%s,%s\r", cmdType, brush, col, x, y);
    writeln("encoded: ", encoded);
    return encoded;
}

unittest {
    Color col = new Color(1, 1, 1);
    char[] encoded = encodeCommand(1, 1, col, 1, 1);
    assert("1,1,(1|1|1),1,1\r" == encoded);
}

unittest {
    Color col = new Color(1, 1, 1);
    char[] encoded = encodeCommand(1, 1, col, SKIP_VALUE, 1);
    assert("1,1,(1|1|1),,1\r" == encoded);
}

unittest {
    Color col = new Color(1, 1, 1);
    char[] encoded = encodeCommand(1, 1, col, 1, 1);
    assert("1,1,,1,1\r" == encoded);
}

unittest {
    Color col = new Color(1, 1, 1);
    char[] encoded = encodeCommand(1, SKIP_VALUE, col, 1, 1);
    assert("1,,(1|1|1),1,1\r" == encoded);
}

unittest {
    Color col = new Color(1, 1, 1);
    char[] encoded = encodeCommand(SKIP_VALUE, 1, col, 1, 1);
    assert(",1,(1|1|1),1,1\r" == encoded);
}

unittest {
    Color col = new Color(1, 1, 1);
    char[] encoded = encodeCommand(1, 1, col, 1, SKIP_VALUE);
    assert("1,1,(1|1|1),1,\r" == encoded);
}

Command decodePacketToCommand(char[] message, long size) {
    char[][] fields = message[0 .. size].split(',');
    // Color cmdColor = Color(to!string(fields[2]));
    Color cmdColor = Color(255, 255, 255);
    return new DrawPixelCommand(1, 1, cmdColor);
}

unittest {
    char[] packet = "1,1,(1,1,1),1,1\r";
    long size = 13;
    Command cmd = decodePacketToCommand(packet, size);
}

// void main() {
//     int x =1;
// }
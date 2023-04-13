module controller.EncodeDecode;

// Imports.
import std.conv;
import std.stdio;
import std.format;
import std.array;

import controller.commands.Command;
import view.components.MyDrawing;
import controller.commands.DrawPointCommand : DrawPointCommand;
import controller.Color;

import gdk.RGBA; // RGBA.

int SKIP_VALUE = -1;

char[] encodeCommand(int commandType, int brushSize, Color color, int xPos, int yPos)
{
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

//unittest {
//    Color col = new Color(1, 1, 1);
//    char[] encoded = encodeCommand(1, 1, col, 1, 1);
//    assert("1,1,(1|1|1),1,1\r" == encoded);
//}
//
//unittest {
//    Color col = new Color(1, 1, 1);
//    char[] encoded = encodeCommand(1, 1, col, SKIP_VALUE, 1);
//    assert("1,1,(1|1|1),,1\r" == encoded);
//}
//
//unittest {
//    Color col = new Color(1, 1, 1);
//    char[] encoded = encodeCommand(1, 1, col, 1, 1);
//    assert("1,1,,1,1\r" == encoded);
//}
//
//unittest {
//    Color col = new Color(1, 1, 1);
//    char[] encoded = encodeCommand(1, SKIP_VALUE, col, 1, 1);
//    assert("1,,(1|1|1),1,1\r" == encoded);
//}
//
//unittest {
//    Color col = new Color(1, 1, 1);
//    char[] encoded = encodeCommand(SKIP_VALUE, 1, col, 1, 1);
//    assert(",1,(1|1|1),1,1\r" == encoded);
//}
//
//unittest {
//    Color col = new Color(1, 1, 1);
//    char[] encoded = encodeCommand(1, 1, col, 1, SKIP_VALUE);
//    assert("1,1,(1|1|1),1,\r" == encoded);
//}

Command decodePacketToCommand(char[] message, long size)
{
    char[][] fields = message[0 .. size].split(',');
    writeln(fields);
    // Color cmdColor = Color(to!string(fields[2]));
    RGBA cmdColor = new RGBA(255, 255, 255, 255);
    return new DrawPointCommand(100, 100, cmdColor, 5, new MyDrawing(), 1);
}

Command decodePacketToCommandString(string message, long size)
{
    char[] m;
    m ~= message;
    char[][] fields = m[0 .. size - 1].split(',');
    writeln(fields);
    // Color cmdColor = Color(to!string(fields[2]));
    RGBA cmdColor = new RGBA(255, 255, 255, 255);
    return new DrawPointCommand(100, 100, cmdColor, 5, new MyDrawing(), 1);
}

//unittest {
//    char[] packet = "1,1,(1,1,1),1,1\r";
//    long size = 13;
//    Command cmd = decodePacketToCommand(packet, size);
//}

// void main() {
//     int x =1;
// }

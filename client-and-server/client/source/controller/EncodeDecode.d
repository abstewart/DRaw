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

/// Encode the command. Take in the command type, brush size, color, and x and y coordinates. Translate that information into a char[].
char[] encodeCommand(int commandType, int brushSize, Color color, int xPos, int yPos)
{
    char[] encoded = [];
    string cmdType = (commandType == SKIP_VALUE) ? "" : to!string(commandType);
    string brush = (brushSize == SKIP_VALUE) ? "" : to!string(brushSize);
    string col = !color.isValidColor() ? "" : color.toEncodedString();
    string x = (xPos == SKIP_VALUE) ? "" : to!string(xPos);
    string y = (yPos == SKIP_VALUE) ? "" : to!string(yPos);
    encoded ~= format("%s,%s,%s,%s,%s\r", cmdType, brush, col, x, y);
    return encoded;
}

/// Decode the command packet taking the message in as a char[].
Command decodePacketToCommand(char[] message, long size)
{
    char[][] fields = message[0 .. size].split(',');
    RGBA cmdColor = new RGBA(255, 255, 255, 255);
    return new DrawPointCommand(100, 100, cmdColor, 5, new MyDrawing(), 1);
}

/// Decode the command packet taking the message in as a string.
Command decodePacketToCommandString(string message, long size)
{
    char[] m;
    m ~= message;
    char[][] fields = m[0 .. size - 1].split(',');
    RGBA cmdColor = new RGBA(255, 255, 255, 255);
    return new DrawPointCommand(100, 100, cmdColor, 5, new MyDrawing(), 1);
}
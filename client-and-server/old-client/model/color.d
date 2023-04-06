module color;

import std.conv;
import std.array;
import std.format;

/**
* Represents a color in RGBA format.
*/
struct Color
{
    private ubyte r;
    private ubyte g;
    private ubyte b;
    private bool isValid;

    /**
    * Constructs a dummy color object with no meaningful data
    * Params:
    *        validity = a boolean representing the intended validity of the color
    */
    this(bool validity)
    {
        this.r = 0;
        this.g = 0;
        this.b = 0;
        this.isValid = false;
    }

    /**
    * Constructs a color from a templated string representing an RGB color value
    * Params: 
    *        packedString = a string in the format (r|g|b)
    */
    this(string packedString)
    {
        string[] fields = packedString[1 .. $ - 1].split('|');
        this.r = to!ubyte(fields[0]);
        this.g = to!ubyte(fields[1]);
        this.b = to!ubyte(fields[2]);
        this.isValid = true;
    }

    /**
    * Constructs a color given a red, green, blue, and alpha component.
    * Params: 
    *        r =    red component of rgba
    *        b =    blue component of rgba
    *        g =    green component of rgba
    */
    this(ubyte r, ubyte g, ubyte b)
    {
        this.r = r;
        this.g = g;
        this.b = b;
        this.isValid = true;
    }
    /**
    * Gets the red component of the color
    */
    ubyte getRed()
    {
        return this.r;
    }

    /**
    * Gets the blue component of the color
    */
    ubyte getBlue()
    {
        return this.b;
    }

    /**
    * gets the green component of the color
    */
    ubyte getGreen()
    {
        return this.g;
    }

    /**
    * Checks whether a color is intended to be valid or not
    */
    bool isValidColor()
    {
        return this.isValid;
    }

    /**
    * returns an encoded tuple representing the color value
    */
    string toEncodedString()
    {
        return format("(%s|%s|%s)", to!string(this.r), to!string(this.g), to!string(this.b));
    }

}

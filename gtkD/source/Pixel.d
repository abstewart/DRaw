// Imports.
private import std.stdio;                               // writeln.

private import gdk.RGBA;                                // RGBA.

/// Class representing a pixel on the ImageSurface surface in MyDrawing.d.
class Pixel {
    // Instance variables.
    private:
    int x;
    int y;
    RGBA currentColor;
    RGBA previousColor;

    /// Constructor.
    public:
    this(int x, int y, RGBA currentColor, RGBA previousColor) {
        this.x = x;
        this.y = y;
        this.currentColor = currentColor;
        this.previousColor = previousColor;
    }

    /// Deconstructor.
    ~this() {
        writeln("Pixel destructor");
    }

    /// Getter method -- gets the x coordinate of the pixel.
    public int getX() {
        writeln("getX");
        return this.x;
    }

    /// Getter method -- gets the y coordinate of the pixel.
    public int getY() {
        writeln("getY");
        return this.y;
    }
    /// Getter method -- gets the current color of the pixel.
    public RGBA getCurrentColor() {
        writeln("getCurrentColor");
        return this.currentColor;
    }

    /// Getter method -- gets the previous color of the pixel.
    public RGBA getPreviousColor() {
        writeln("getPreviousColor");
        return this.previousColor;
    }

    /// Setter method -- sets the current color to the previous color. Used when undoing a DrawPixelCommand.
    public void setCurrentColor() {
        writeln("setCurrentColor");
        this.currentColor = this.previousColor;
    }
}
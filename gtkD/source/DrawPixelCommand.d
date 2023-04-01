// Imports.
private import std.stdio;                               // writeln.
private import std.math;                                // PI.

private import Command : Command;
private import MyDrawing : MyDrawing;

private import cairo.Context;                           // Context.
private import cairo.ImageSurface;                      // ImageSurface.

private import gdk.RGBA;                                // RGBA.

private import gtk.SpinButton;                          // SpinButton.

/// Class representing the draw pixel command.
class DrawPixelCommand : Command {
    private:
    CairoOperator operator = CairoOperator.OVER;
    int x;
    int y;
    RGBA rgbaColor;
    Context context;
    int width;
    string primitiveType;

    /// Constructor.
    public:
    this(int x, int y, Context context, RGBA rgbaColor, int width, string primitiveType) {
        this.x = x;
        this.y = y;
        this.context = context;
        this.rgbaColor = rgbaColor;
        this.width = width;
        this.primitiveType = primitiveType;
    }

    /// Destructor.
    ~this() {
        writeln("DrawPixelCommand destructor");
    }

    /// The execute method -- draw/paint.
    public int Execute() {
        int height = this.width * 3 / 4;
        this.context.setOperator(this.operator);
        const double ALPHAVALUE = 1.0;
        double rValue = this.rgbaColor.red();
        double gValue = this.rgbaColor.green();
        double bValue = this.rgbaColor.blue();
        // Set the color of the brush/pen.
        this.context.setSourceRgba(rValue, gValue, bValue, ALPHAVALUE);

        debug(trace) {
            writefln("primitiveType = %s", this.primitiveType);
        }

        switch (this.primitiveType) {
            case "Arc":
            this.context.arc(this.x - this.width / 2, this.y - this.width / 2, this.width, 0, 2 * PI);
            this.context.stroke();
            break ;
            case "Filled Arc":
            this.context.arc(this.x - this.width / 4, this.y - this.width / 4, this.width / 2, 0, 2 * PI);
            this.context.fill();
            break ;
            case "Line":
            this.context.moveTo(this.x, this.y);
            this.context.lineTo(this.x + this.width, this.y);
            this.context.stroke();
            break ;
            case "Point":
            this.context.rectangle(this.x, this.y, 1, 1);
            this.context.fill();
            break ;
            case "Rectangle":
            this.context.rectangle(this.x - this.width / 2, this.y - this.width / 4, this.width, height);
            this.context.stroke();
            break ;
            case "Filled Rectangle":
            this.context.rectangle(this.x - this.width / 2, this.y - this.width / 4, this.width, height);
            this.context.fill();
            break ;
            default:
            this.context.arcNegative(this.x  -2, this.y - 2, 4, 0, 6);
            this.context.fill();
            break ;
        }

        return 0;
    }

    /// The undo method -- undo the Execute command.
    public int Undo() {
        // TODO
        return 0;
    }
}
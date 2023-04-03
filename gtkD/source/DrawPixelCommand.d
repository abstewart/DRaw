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
    // Instance variables.
    private:
    CairoOperator operator = CairoOperator.OVER;
    int x;
    int y;
    ImageSurface surface;
    Context context;
    RGBA currentColor;
    RGBA previousColor;
    int width;
    string primitiveType;
    MyDrawing myDrawing;

    /// Constructor.
    public:
    this(int x, int y, RGBA currentColor, RGBA previousColor, int width, string primitiveType, MyDrawing myDrawing) {
        this.x = x;
        this.y = y;
        this.myDrawing = myDrawing;
        this.surface = myDrawing.getImageSurface();
        this.context = Context.create(this.surface);
        this.currentColor = currentColor;
        writeln("DrawPixelCommand constructor. The current brush color is: ", this.currentColor.toString());
        this.previousColor = previousColor;
        if (this.previousColor is null) {
            writeln("DrawPixelCommand constructor. The previous color is: null");
        } else {
            writeln("DrawPixelCommand constructor. The previous brush color is: ", this.previousColor.toString());
        }
        this.width = width;
        this.primitiveType = primitiveType;
    }

    /// Destructor.
    ~this() {
        writeln("DrawPixelCommand destructor");
    }

    /// The execute method -- draw/paint.
    public int execute() {
        int height = this.width * 3 / 4;
        this.context.setOperator(this.operator);
        const double ALPHAVALUE = 1.0;
        double rValue = this.currentColor.red();
        double gValue = this.currentColor.green();
        double bValue = this.currentColor.blue();
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

        // Redraw the Widget.
        this.myDrawing.queueDraw();
        return 0;
    }

    /// The undo method -- undo the Execute command.
    public int undo() {
        // TODO
        // Redraw/repaint to the previous color.
        return 0;
    }
}
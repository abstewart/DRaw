module drawLineCommand;

// Imports.
private import std.stdio;                               // writeln.
private import std.math;                                // PI.

private import Command : Command;
private import MyDrawing : MyDrawing;

private import cairo.Context;                           // Context.
private import cairo.ImageSurface;                      // ImageSurface.

private import gdk.RGBA;                                // RGBA.

private import gtk.SpinButton;                          // SpinButton.

/// Class representing the draw command with a line brush type.
class DrawLineCommand : Command {
    // Instance variables.
    private:
    CairoOperator operator = CairoOperator.OVER;
    int x;
    int y;
    RGBA currentColor;
    ImageSurface surface;
    Context context;
    int width;
    MyDrawing myDrawing;

    /// Constructor.
    public:
    this(int x, int y, RGBA currentColor, int width, MyDrawing myDrawing) {
        writeln("DrawLineCommand constructor");
        this.x = x;
        this.y = y;
        this.currentColor = currentColor;
        this.width = width;
        this.myDrawing = myDrawing;
        this.surface = myDrawing.getImageSurface();
        this.context = Context.create(this.surface);
    }

    /// Destructor.
    ~this() {
        writeln("DrawLineCommand destructor");
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

        this.context.moveTo(this.x, this.y);
        this.context.lineTo(this.x + this.width, this.y);
        this.context.stroke();

        // Redraw the Widget.
        this.myDrawing.queueDraw();
        return 0;
    }

    /// The undo method -- undo the Execute command.
    public int undo() {
        // ===================================================================================
        // TODO: Get this functionality to work.
        // ===================================================================================
        return 0;
    }
}
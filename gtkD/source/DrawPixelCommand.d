// Imports.
private import std.stdio;                               // writeln.
private import std.math;                                // PI.

private import Command : Command;
private import MyDrawing : MyDrawing;
private import Pixel : Pixel;

private import cairo.Context;                           // Context.
private import cairo.ImageSurface;                      // ImageSurface.

private import gdk.RGBA;                                // RGBA.

private import gtk.SpinButton;                          // SpinButton.

/// Class representing the draw pixel command.
class DrawPixelCommand : Command {
    // Instance variables.
    private:
    CairoOperator operator = CairoOperator.OVER;
    Pixel pixel;
    ImageSurface surface;
    Context context;
    int width;
    string brushType;
    MyDrawing myDrawing;

    /// Constructor.
    public:
    this(int x, int y, RGBA currentColor, RGBA previousColor, int width, string brushType, MyDrawing myDrawing) {
        this.pixel = new Pixel(x, y, currentColor, previousColor);
        this.width = width;
        this.brushType = brushType;
        this.myDrawing = myDrawing;
        this.surface = myDrawing.getImageSurface();
        this.context = Context.create(this.surface);
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
        double rValue = this.pixel.getCurrentColor().red();
        double gValue = this.pixel.getCurrentColor().green();
        double bValue = this.pixel.getCurrentColor().blue();
        // Set the color of the brush/pen.
        this.context.setSourceRgba(rValue, gValue, bValue, ALPHAVALUE);

        debug(trace) {
            writefln("brushType = %s", this.brushType);
        }

        switch (this.brushType) {
            case "Arc":
            this.context.arc(this.pixel.getX() - this.width / 2, this.pixel.getY() - this.width / 2, this.width, 0, 2 * PI);
            this.context.stroke();
            break ;
            case "Filled Arc":
            this.context.arc(this.pixel.getX() - this.width / 4, this.pixel.getY() - this.width / 4, this.width / 2, 0, 2 * PI);
            this.context.fill();
            break ;
            case "Line":
            this.context.moveTo(this.pixel.getX(), this.pixel.getY());
            this.context.lineTo(this.pixel.getX() + this.width, this.pixel.getY());
            this.context.stroke();
            break ;
            case "Point":
            this.context.rectangle(this.pixel.getX(), this.pixel.getY(), 1, 1);
            this.context.fill();
            break ;
            case "Rectangle":
            this.context.rectangle(this.pixel.getX() - this.width / 2, this.pixel.getY() - this.width / 4, this.width, height);
            this.context.stroke();
            break ;
            case "Filled Rectangle":
            this.context.rectangle(this.pixel.getX() - this.width / 2, this.pixel.getY() - this.width / 4, this.width, height);
            this.context.fill();
            break ;
            default:
            this.context.arcNegative(this.pixel.getX()  -2, this.pixel.getY() - 2, 4, 0, 6);
            this.context.fill();
            break ;
        }

        // Redraw the Widget.
        this.myDrawing.queueDraw();
        return 0;
    }

    /// The undo method -- undo the Execute command.
    public int undo() {
        // ===================================================================================
        // TODO
        // Redraw/repaint to the previous color.
        // Reset this.currentColor to equal previous color and then execute/draw/paint the pixel.
        //this.pixel.setCurrentColor();
        //execute();
        // ===================================================================================
        return 0;
    }
}
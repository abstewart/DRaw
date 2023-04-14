module controller.commands.Command;

// Imports.
protected import cairo.Context;

protected import cairo.ImageSurface; //ImageSurface
protected import gdk.Pixbuf; //PixBuf
protected import gdk.Cairo;

protected import view.components.MyDrawing;

protected import gdk.RGBA; // RGBA.

protected import std.format;

protected import std.stdio;

/// Represents a set of common characteristics for a drawing command.
abstract class Command
{
    // Instance variables.
protected:
    static immutable CairoOperator operator = CairoOperator.OVER;
    ImageSurface surface;
    Context context;
    MyDrawing myDrawing;
    RGBA currentColor;
    int ulX;
    int ulY;
    Pixbuf oldPB;
    int id;

    /**
    * Constructor used amongst all the non-abstract classes that inherit this class.
    * Params:
    *        myDrawing = the client's drawing surface
    *        color = the color of the paint brush for this command
    *        ulx = the upper left x
    *        uly = the upper left y
    *        id = the command id
    */
public:
    this(MyDrawing myDrawing, RGBA color, int ulx, int uly, int id)
    {
        this.currentColor = color;
        this.myDrawing = myDrawing;
        this.surface = this.myDrawing.getImageSurface();
        this.context = Context.create(this.surface);
        // Set the upper left x & y.
        this.ulX = ulx;
        this.ulY = uly;
        this.id = id;
    }

    /// Destructor.
    ~this()
    {
    }

    /// Getter method -- gets the command type.
    abstract public int getCmdType();

    /// Getter method -- gets the command id.
    final public int getCmdId()
    {
        return this.id;
    }

    /// Function for updating the pixels (drawing/painting).
    abstract public int execute();

    /// Function for undoing an Execute command.
    public int undo()
    {
        this.context.save();
        setSourcePixbuf(this.context, oldPB, this.ulX, this.ulY);
        this.context.paint();
        this.context.restore();
        this.myDrawing.queueDraw();
        return 0;
    }

    /// Function to save specified area to the given ImageSurface.
    final void saveOldRect(int width, int height)
    {
        // Capture the region in question.
        oldPB = getFromSurface(this.surface, this.ulX, this.ulY, width, height);
    }

    /// Getter method -- gets the color is string format.
    final string getColorString()
    {
        return "%s|%s|%s|%s".format(this.currentColor.red, this.currentColor.green,
                this.currentColor.blue, this.currentColor.alpha);
    }

    /// Abstract method to encode the command. Child classes will override this method.
    abstract string encode();
}
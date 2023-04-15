module controller.commands.Command;

protected import cairo.Context;
protected import cairo.ImageSurface; 
protected import gdk.Pixbuf; 
protected import gdk.Cairo;
protected import gdk.RGBA;

protected import std.format;
protected import std.stdio;

protected import view.components.MyDrawing;

/// Represents a set of common characteristics for a drawing command.
abstract class Command
{
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
 *
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

    /// Gets the command type.
    abstract public int getCmdType();

    /// Gets the command id.
    final public int getCmdId()
    {
        return this.id;
    }

    /**
     * Executes the command on the canvas
     */
    abstract public void execute();

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
        oldPB = getFromSurface(this.surface, this.ulX, this.ulY, width, height);
    }

    /// Gets the color in string format.
    final string getColorString()
    {
        return "%s|%s|%s|%s".format(this.currentColor.red, this.currentColor.green,
                this.currentColor.blue, this.currentColor.alpha);
    }

    /// Abstract method to encode the command into a string. Child classes will override this method.
    abstract string encode();
}

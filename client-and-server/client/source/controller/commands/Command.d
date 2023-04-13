module controller.commands.Command;

protected import cairo.Context;

protected import cairo.ImageSurface; //ImageSurface
protected import gdk.Pixbuf; //PixBuf
protected import gdk.Cairo;

protected import view.components.MyDrawing;

protected import gdk.RGBA; // RGBA.

protected import std.format;

import std.stdio;

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

public:
    this(MyDrawing myDrawing, RGBA color, int ulx, int uly, int id)
    {
        this.currentColor = color;
        this.
        this.surface = myDrawing.getImageSurface();
        this.context = Context.create(this.surface);
        //set the uppser left x & y
        this.ulX = ulx;
        this.ulY = uly;
        this.id = id;
    }
    /// Function for getting the command type
    abstract public int getCmdType();

    /// Function for getting the command id
    final public int getCmdId()
    {
        return this.id;
    }
    /// Function for updating the pixels (drawing/painting).
    abstract public int execute();

    /// Function for undoing an Execute command.
    public int undo()
    {
        //this.executeUndo(this.x - this.width / 2, this.y - this.width/4, this.oldPB, this.context);
        writeln("Undo called");
        this.context.save();
        setSourcePixbuf(this.context, oldPB, this.ulX, this.ulY);
        this.context.paint();
        this.context.restore();

        this.myDrawing.queueDraw();

        return 0;
    }

    /// Function to save specified area to the given ImageSurface
    final void saveOldRect(int width, int height)
    {
        //capture the region in question
        oldPB = getFromSurface(this.surface, this.ulX, this.ulY, width, height);
        //getFromSurface(this.surface, x, y, width, height);
        /*
        //create the surface to store the region
        destImgSurface = ImageSurface.create(CairoFormat.ARGB32, width, height);
        //create the context to paint with
        auto ctx = Context.create(destImgSurface);
        //set the source pixbuf to created one
        setSourcePixbuf(ctx, oldPB, 0, 0);
        //paint to the destSurface
        ctx.paint();
        */
    }

    final string getColorString()
    {
        return "%s|%s|%s|%s".format(this.currentColor.red, this.currentColor.green,
                this.currentColor.blue, this.currentColor.alpha);
    }

    abstract string encode();

    final void executeUndo()
    {
        // comment
    }
}

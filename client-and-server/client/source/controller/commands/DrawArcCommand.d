module controller.commands.DrawArcCommand;

// Imports.
private import std.stdio; // writeln.
private import std.math; // PI.

private import controller.commands.Command;

private import gtk.SpinButton;

immutable int ARC_TYPE = 0;

/// Implements functionality for drawing and undoing an 'Arc' on a Cairo Canvas
class DrawArcCommand : Command
{

private:
    int x;
    int y;
    int width;

    /// Constructor.

public:
    this(int x, int y, RGBA currentColor, int width, MyDrawing myDrawing, int id)
    {

        super(myDrawing, currentColor, x - width / 2, y - width / 2, id);

        writeln("DrawArcCommand constructor");
        this.x = x;
        this.y = y;
        this.width = width;
    }

    /// Destructor.
    ~this()
    {

    }

    /// The execute method -- draw/paint.
    override public int execute()
    {
        int height = this.width * 3 / 4;
        this.context.setOperator(this.operator);
        const double ALPHAVALUE = 1.0;
        double rValue = this.currentColor.red();
        double gValue = this.currentColor.green();
        double bValue = this.currentColor.blue();
        // Set the color of the brush/pen.
        this.context.setSourceRgba(rValue, gValue, bValue, ALPHAVALUE);

        //save the old img
        this.saveOldRect(this.width, this.width);

        this.context.arc(this.x - this.width / 4, this.y - this.width / 4, this.width / 2, 0, 2 * PI);
        this.context.stroke();

        // Redraw the Widget.
        this.myDrawing.queueDraw();
        return 0;
    }

    override public int getCmdType()
    {
        return ARC_TYPE;
    }

    override public string encode()
    {
        return "%s,%s,%s,%s,%s,%s".format(this.id, this.getCmdType(),
                this.width, this.x, this.y, this.getColorString());
    }
}

module controller.commands.DrawPointCommand;

// Imports.
private import std.stdio; // writeln.
private import std.math; // PI.

private import controller.commands.Command;

private import gtk.SpinButton; // SpinButton.

immutable int POINT_TYPE = 4;

/// Class representing the draw command with a point brush type.
class DrawPointCommand : Command
{
    // Instance variables.
    private:
    int x;
    int y;
    int width;

    Pixbuf oldPB;

    /// Constructor.
    public:
    this(int x, int y, RGBA currentColor, int width, MyDrawing myDrawing, int id)
    {
        super(myDrawing, currentColor, x, y, id);
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
        this.context.setOperator(this.operator);
        const double ALPHAVALUE = 1.0;
        double rValue = this.currentColor.red();
        double gValue = this.currentColor.green();
        double bValue = this.currentColor.blue();
        // Set the color of the brush/pen.
        this.context.setSourceRgba(rValue, gValue, bValue, ALPHAVALUE);

        // Save the point.
        this.saveOldRect(1, 1);

        this.context.rectangle(this.x, this.y, 1, 1);
        this.context.fill();

        // Redraw the Widget.
        this.myDrawing.queueDraw();
        return 0;
    }

    /// Getter method -- get the command type.
    override public int getCmdType()
    {
        return POINT_TYPE;
    }

    /// Encode the command with its information.
    override public string encode()
    {
        return "%s,%s,%s,%s,%s,%s".format(this.id, this.getCmdType(),
        this.width, this.x, this.y, this.getColorString());
    }
}

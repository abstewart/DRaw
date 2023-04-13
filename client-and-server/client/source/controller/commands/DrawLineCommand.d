module controller.commands.DrawLineCommand;

// Imports.
private import std.stdio; // writeln.
private import std.math; // PI.

private import controller.commands.Command;

private import gtk.SpinButton; // SpinButton.

immutable int LINE_TYPE = 3;

/// Class representing the draw command with a line brush type.
class DrawLineCommand : Command
{
    // Instance variables.
private:
    int x;
    int y;

    int width;

    /// Constructor.
public:
    this(int x, int y, RGBA currentColor, int width, MyDrawing myDrawing, int id)
    {
        super(myDrawing, currentColor, x, y, id);

        writeln("DrawLineCommand constructor");
        this.x = x;
        this.y = y;
        this.width = width;

    }

    /// Destructor.
    ~this()
    {
        writeln("DrawLineCommand destructor");
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

        //save old img
        this.saveOldRect(this.width, 2);

        this.context.moveTo(this.x, this.y);
        this.context.lineTo(this.x + this.width, this.y);
        this.context.stroke();

        // Redraw the Widget.
        this.myDrawing.queueDraw();
        return 0;
    }

    override public int getCmdType()
    {
        return LINE_TYPE;
    }

    override public string encode()
    {
        return "%s,%s,%s,%s,%s,%s".format(this.id, this.getCmdType(),
                this.width, this.x, this.y, this.getColorString());
    }
}

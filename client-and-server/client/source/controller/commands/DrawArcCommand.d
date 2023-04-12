module controller.commands.DrawArcCommand;

// Imports.
private import std.stdio; // writeln.
private import std.math; // PI.

private import controller.commands.Command;

private import gtk.SpinButton; // SpinButton.

/// Class representing the draw command with an arc brush type.
class DrawArcCommand : Command
{
    // Instance variables.
private:
    int x;
    int y;
    int width;

    /// Constructor.

public:
    this(int x, int y, RGBA currentColor, int width, MyDrawing myDrawing)
    {
        super(myDrawing, currentColor, x - width / 2, y - width / 2);

        writeln("DrawArcCommand constructor");
        this.x = x;
        this.y = y;
        this.width = width;
    }

    /// Destructor.
    ~this()
    {
        writeln("DrawArcCommand destructor");
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

    override public char[] encode()
    {
        return ['c', 'h', 'a'];
    }
}

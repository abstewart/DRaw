module controller.commands.DrawPointCommand;

// Imports.
private import std.stdio; // writeln.
private import std.math; // PI.

private import controller.commands.Command;

private import gtk.SpinButton; // SpinButton.

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
    this(int x, int y, RGBA currentColor, int width, MyDrawing myDrawing)
    {

        super(myDrawing, currentColor, x, y);
        writeln("DrawPointCommand constructor");
        this.x = x;
        this.y = y;
        this.width = width;

    }

    /// Destructor.
    ~this()
    {
        writeln("DrawPointCommand destructor");
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

        //save the point
        this.saveOldRect(1, 1);

        this.context.rectangle(this.x, this.y, 1, 1);
        this.context.fill();

        // Redraw the Widget.
        this.myDrawing.queueDraw();
        return 0;
    }

    override public char[] encode()
    {
        return ['c', 'h', 'a'];
    }
}

module controller.commands.DrawFilledRectangleCommand;
// Imports.
private import std.stdio; // writeln.
private import std.math; // PI.

private import controller.commands.Command;

private import gtk.SpinButton; // SpinButton.

immutable int FILLED_RECT_TYPE = 2;

/// Class representing the draw command with a filled rectangle brush type.
class DrawFilledRectangleCommand : Command
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
        super(myDrawing, currentColor, x - width / 2, y - width / 4, id);
        writeln("DrawFilledRectangleCommand constructor");
        this.x = x;
        this.y = y;
        this.width = width;

    }

    /// Destructor.
    ~this()
    {
        writeln("DrawFilledRectangleCommand destructor");
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

        //save old oldPB
        this.saveOldRect(this.width, height);

        this.context.rectangle(this.x - this.width / 2, this.y - this.width / 4, this.width, height);
        this.context.fill();

        // Redraw the Widget.
        this.myDrawing.queueDraw();
        return 0;
    }

    override public int getCmdType()
    {
        return FILLED_RECT_TYPE;
    }

    override public string encode()
    {
        return "%s,%s,%s,%s,%s,%s".format(this.id, this.getCmdType(),
                this.width, this.x, this.y, this.getColorString());
    }
}

module controller.commands.DrawLineCommand;

// Imports.
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

    /**
    * Constructs a DrawLineCommand instance.
    * Params:
    *        x = the x coordinate of the mouse
    *        y = the y coordinate of the mouse
    *        currentColor = the color of the paint brush for this command
    *        width = the brush size (dictated my what the user sets in the spin in MyDrawing.d)
    *        myDrawing = the client's drawing surface
    *        id = the command id
    */
public:
    this(int x, int y, RGBA currentColor, int width, MyDrawing myDrawing, int id)
    {
        super(myDrawing, currentColor, x, y - 2, id);
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

        // Save old image.
        this.saveOldRect(this.width, 3);

        this.context.moveTo(this.x, this.y);
        this.context.lineTo(this.x + this.width, this.y);
        this.context.stroke();

        // Redraw the Widget.
        this.myDrawing.queueDraw();
        return 0;
    }

    /// Getter method -- get the command type.
    override public int getCmdType()
    {
        return LINE_TYPE;
    }

    /// Encode the command with its information.
    override public string encode()
    {
        return "%s,%s,%s,%s,%s,%s".format(this.id, this.getCmdType(),
                this.width, this.x, this.y, this.getColorString());
    }
}
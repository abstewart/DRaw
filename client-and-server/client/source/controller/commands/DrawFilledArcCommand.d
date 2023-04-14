module controller.commands.DrawFilledArcCommand;

// Imports.
private import std.math; // PI.

private import controller.commands.Command;

private import gtk.SpinButton; // SpinButton.

immutable int FILLED_ARC_TYPE = 1;

/// Class representing the draw command with a filled arc brush type.
class DrawFilledArcCommand : Command
{
    // Instance variables.
private:
    int x;
    int y;
    int width;

    /**
    * Constructs a DrawArcCommand instance.
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
        super(myDrawing, currentColor, x - width / 2, y - width / 2, id);
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
        this.saveOldRect(this.width, this.width);

        this.context.arc(this.x, this.y, this.width / 2, 0, 2 * PI);
        this.context.fill();

        // Redraw the Widget.
        this.myDrawing.queueDraw();
        return 0;
    }

    /// Getter method -- get the command type.
    override public int getCmdType()
    {
        return FILLED_ARC_TYPE;
    }

    /// Encode the command with its information.
    override public string encode()
    {
        return "%s,%s,%s,%s,%s,%s".format(this.id, this.getCmdType(),
                this.width, this.x, this.y, this.getColorString());
    }
}
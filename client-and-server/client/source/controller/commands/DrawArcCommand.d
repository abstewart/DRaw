module controller.commands.DrawArcCommand;

// Imports.
private import std.math; // PI.

private import controller.commands.Command;

private import gtk.SpinButton;

immutable int ARC_TYPE = 0;

/// Implements functionality for drawing and undoing an 'Arc' on a Cairo Canvas.
class DrawArcCommand : Command
{
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
        super(myDrawing, currentColor, x - width / 2 - 2, y - width / 2 - 2, id);
        this.x = x;
        this.y = y;
        this.width = width;
    }

    /// Destructor.
    ~this()
    {
    }

    /** 
     * Draws an arc on the canvas. 
     */
    override public void execute()
    {
        this.context.setOperator(this.operator);
        const double ALPHAVALUE = 1.0;
        double rValue = this.currentColor.red();
        double gValue = this.currentColor.green();
        double bValue = this.currentColor.blue();
        // Set the color of the brush/pen.
        this.context.setSourceRgba(rValue, gValue, bValue, ALPHAVALUE);

        // Save the old image.
        this.saveOldRect(this.width + 4, this.width + 4);

        this.context.arc(this.x, this.y, this.width / 2, 0, 2 * PI);
        this.context.stroke();

        // Redraw the Widget.
        this.myDrawing.queueDraw();
    }

    /**
     * Gets the command type. For the Arc Command this is 0.
     *
     * Returns: 
     *         - type : int : the type of this commmand
     */
    override public int getCmdType()
    {
        return ARC_TYPE;
    }

    /// Encodes the command as a string of its id, type, width, x, y, and color.
    override public string encode()
    {
        return "%s,%s,%s,%s,%s,%s".format(this.id, this.getCmdType(),
                this.width, this.x, this.y, this.getColorString());
    }
}

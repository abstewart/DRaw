module controller.commands.DrawArcCommand;

private import std.math : PI;

private import controller.commands.Command;

immutable int ARC_TYPE = 0;

/** 
 * Implements functionality for drawing and undoing an 'Arc' on a Cairo Canvas.
 */
class DrawArcCommand : Command
{
private:
    int x;
    int y;
    int width;

public:
    static immutable int cType = ARC_TYPE;

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
    this(int x, int y, RGBA currentColor, int width, MyDrawing myDrawing, int id)
    {
        super(myDrawing, currentColor, x - width / 2 - 2, y - width / 2 - 2, id, ARC_TYPE);
        this.x = x;
        this.y = y;
        this.width = width;
    }

    /** 
     * Draws an arc on the canvas. 
     */
    override public void execute()
    {
        this.context.setOperator(this.operator);
        double alphaValue = this.currentColor.alpha();
        double rValue = this.currentColor.red();
        double gValue = this.currentColor.green();
        double bValue = this.currentColor.blue();
        // Set the color of the brush/pen.
        this.context.setSourceRgba(rValue, gValue, bValue, alphaValue);

        // Save the old image.
        this.saveOldRect(this.width + 4, this.width + 4);

        this.context.arc(this.x, this.y, this.width / 2, 0, 2 * PI);
        this.context.stroke();

        // Redraw the Widget.
        this.myDrawing.queueDraw();
    }

    /**
     * Encodes the command id, type, width, x, y and color in a string.
     */
    override public string encode()
    {
        return "%s,%s,%s,%s,%s,%s".format(this.id, cType, this.width, this.x,
                this.y, this.getColorString());
    }
}

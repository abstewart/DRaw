module controller.commands.DrawPointCommand;

private import controller.commands.Command;

immutable int POINT_TYPE = 4;

/** 
 * Implements functionality for drawing and undoing a 'Point' on a Cairo Canvas.
 */
class DrawPointCommand : Command
{
private:
    int x;
    int y;
    int width;
    Pixbuf oldPB;

public:
    static immutable int cType = POINT_TYPE;

    /**
    * Constructs a DrawPointCommand instance.
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
        super(myDrawing, currentColor, x, y, id, POINT_TYPE);
        this.x = x;
        this.y = y;
        this.width = width;
    }

    /** 
     * Draws a point on the canvas. 
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

        // Save the point.
        this.saveOldRect(1, 1);

        this.context.rectangle(this.x, this.y, 1, 1);
        this.context.fill();

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

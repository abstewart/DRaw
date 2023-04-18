module controller.commands.DrawFilledRectangleCommand;

private import controller.commands.Command;

immutable int FILLED_RECT_TYPE = 2;

/** 
 * Implements functionality for drawing and undoing a 'Filled Rectangle' on a Cairo Canvas.
 */
class DrawFilledRectangleCommand : Command
{
private:
    int x;
    int y;
    int width;

public:
    static immutable int cType = FILLED_RECT_TYPE;

    /**
    * Constructs a DrawFilledRectangleCommand instance.
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
        super(myDrawing, currentColor, x - width / 2, y - width / 4, id, FILLED_RECT_TYPE);
        this.x = x;
        this.y = y;
        this.width = width;
    }

    /** 
     * Draws a filled rectangle on the canvas. 
     */
    override public void execute()
    {
        int height = this.width * 3 / 4;
        this.context.setOperator(this.operator);
        double alphaValue = this.currentColor.alpha();
        double rValue = this.currentColor.red();
        double gValue = this.currentColor.green();
        double bValue = this.currentColor.blue();
        // Set the color of the brush/pen.
        this.context.setSourceRgba(rValue, gValue, bValue, alphaValue);

        // Save old oldPB.
        this.saveOldRect(this.width, height);

        this.context.rectangle(this.x - this.width / 2, this.y - this.width / 4, this.width, height);
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

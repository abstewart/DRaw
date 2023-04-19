module controller.commands.DrawLineCommand;

private import controller.commands.Command;

immutable int LINE_TYPE = 3;

/** 
 * Implements functionality for drawing and undoing a 'Line' on a Cairo Canvas.
 */
class DrawLineCommand : Command
{
private:
    int x;
    int y;
    int width;

public:
    static immutable int cType = LINE_TYPE;

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
    this(int x, int y, RGBA currentColor, int width, MyDrawing myDrawing, int id)
    {
        super(myDrawing, currentColor, x, y - 2, id, LINE_TYPE);
        this.x = x;
        this.y = y;
        this.width = width;
    }

    /** 
     * Draws a line on the canvas. 
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

        // Save old image.
        this.saveOldRect(this.width, 3);

        this.context.moveTo(this.x, this.y);
        this.context.lineTo(this.x + this.width, this.y);
        this.context.stroke();

        // Redraw the Widget.
        this.myDrawing.queueDraw();
    }

    /**
     * Encodes the command id, type, width, x, y and color in a string.
     *
     * Returns:
     *        - encoded : string : comma separated string of fields of this command
     */
    override public string encode()
    {
        return "%s,%s,%s,%s,%s,%s".format(this.id, cType, this.width, this.x,
                this.y, this.getColorString());
    }
}

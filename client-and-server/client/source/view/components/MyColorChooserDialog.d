module view.components.MyColorChooserDialog;

private import gdk.RGBA;
private import gdk.c.types;
private import gtk.ColorChooserDialog;
private import gtk.Dialog;

private import view.components.MyDrawing;

/**
 * Class representing the color chooser dialog the user clicks on.
 */
class MyColorChooserDialog : ColorChooserDialog
{
private:
    string title = "Color Selection";
    DialogFlags flags = GtkDialogFlags.MODAL;
    RGBA selectedColor;
    MyDrawing drawingArea;

public:
    /**
    * Constructs a MyColorChooserDialog instnace.
    * Params:
    *        drawingArea : MyDrawing : the whiteboard the user is drawing on
    */
    this(MyDrawing drawingArea)
    {
        super(title, null);
        // Sets a position constraint for this window.
        // CENTER_ALWAYS = Keep window centered as it changes size, etc.
        setPosition(GtkWindowPosition.CENTER_ALWAYS);
        addOnResponse(&doSomething); // Emitted when an action widget is clicked, the dialog receives a delete event, or the application programmer calls Dialog.response.
        this.drawingArea = drawingArea;
    }

    /**
     * Executes the control flow depending on the option the user selected within the dialogue
     *
     * Params:
     *       - response : int : represents which dialogue option the user chose
     *       - d        : Dialogue : the dialogue object
     */
    private void doSomething(int response, Dialog d)
    {
        getRgba(selectedColor);
        this.drawingArea.updateBrushColor(selectedColor);
    }
}

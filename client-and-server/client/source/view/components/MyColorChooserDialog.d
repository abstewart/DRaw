module view.components.MyColorChooserDialog;

// Imports.
private import view.components.MyDrawing;

private import gdk.RGBA; // RGBA.
private import gdk.c.types; // GtkWindowPosition.

private import gtk.ColorChooserDialog; // ColorChooserDialog.
private import gtk.Dialog; // Dialog.

/// Class representing the color chooser dialog the user clicks on.
class MyColorChooserDialog : ColorChooserDialog
{
    // Instance variables.
private:
    string title = "Color Selection";
    DialogFlags flags = GtkDialogFlags.MODAL;
    RGBA selectedColor;
    MyDrawing drawingArea;

    /**
    * Constructs a MyColorChooserDialog instnace.
    * Params:
    *        drawingArea = the whiteboard the user is drawing on
    */
public:
    this(MyDrawing drawingArea)
    {
        super(title, null);
        // Sets a position constraint for this window.
        // CENTER_ALWAYS = Keep window centered as it changes size, etc.
        setPosition(GtkWindowPosition.CENTER_ALWAYS);
        addOnResponse(&doSomething); // Emitted when an action widget is clicked, the dialog receives a delete event, or the application programmer calls Dialog.response.
        this.drawingArea = drawingArea;
    }

    /// Destructor.
    ~this()
    {
    }

    // React based on which response the user picked.
    private void doSomething(int response, Dialog d)
    {
        getRgba(selectedColor);
        this.drawingArea.updateBrushColor(selectedColor);
    }
}
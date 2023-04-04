// Imports.
private import std.stdio;                                               // writeln.

private import MyDrawing : MyDrawing;

private import gdk.RGBA;                                // RGBA.

private import gtk.ColorChooserDialog;                  // ColorChooserDialog.
private import gtk.Dialog;                              // Dialog.

/// Class representing the color chooser dialog the user clicks on. NOTE: If you click outside of MyColorChooserDialog, the main application screen will cover it. You need to close MyColorChooserDialog before doing anything else.
class MyColorChooserDialog : ColorChooserDialog {
    // Instance variables.
    private:
    string title = "Color Selection";
    DialogFlags flags = GtkDialogFlags.MODAL;
    RGBA selectedColor;
    MyDrawing drawingArea;

    /// Constructor.
    public:
    this(MyDrawing drawingArea) {
        super(title, null);
        writeln("MyColorChooserDialog constructor");
        addOnResponse(&doSomething);        // Emitted when an action widget is clicked, the dialog receives a delete event, or the application programmer calls Dialog.response.
        this.drawingArea = drawingArea;
    }

    /// Destructor.
    ~this() {
        writeln("MyColorChooserDialog destructor");
    }

    // React based on which response the user picked.
    private void doSomething(int response, Dialog d) {
        getRgba(selectedColor);
        writeln("New color selection: ", selectedColor);
        this.drawingArea.updateBrushColor(selectedColor);
    }
}
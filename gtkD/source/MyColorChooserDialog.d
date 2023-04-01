// Imports.
private import std.stdio;                                               // writeln.

private import MyDrawing : MyDrawing;

private import gdk.RGBA;                                // RGBA.

private import gtk.ColorChooserDialog;                  // ColorChooserDialog.
private import gtk.Dialog;                              // Dialog.

class MyColorChooserDialog : ColorChooserDialog {
    private:
    string title = "Color Selection";
    DialogFlags flags = GtkDialogFlags.MODAL;
    RGBA selectedColor;
    MyDrawing drawingArea;

    public:
    this(MyDrawing drawingArea) {
        super(title, null);
        addOnResponse(&doSomething);
        this.drawingArea = drawingArea;
    }

    public void doSomething(int response, Dialog d) {
        getRgba(selectedColor);
        writeln("New color selection: ", selectedColor);
        this.drawingArea.updateBrushColor(selectedColor);
    }
}
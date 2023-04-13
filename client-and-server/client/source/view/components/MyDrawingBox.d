module view.components.MyDrawingBox;

// Imports.
private import std.stdio; // writeln.

private import view.components.MyDrawing;
private import view.components.MyColorChooserDialog;
private import controller.commands.Command;
private import view.components.BrushTypeComboBoxText;

private import gtk.VBox; // VBox.
private import gtk.Button; // Button.
private import gtk.Label; // Label.
private import gtk.HBox; // HBox.

/// Class representing the box that the users drawing sits in. Includes the brush type, brush size, color picker, undo, and save options.
class MyDrawingBox : VBox
{
    // Instance variables.
private:
    MyDrawing drawingArea;
    MyColorChooserDialog d;

    /// Constructor.
public:
    this()
    {
        super(false, 4); // this(bool homogeneous, int spacing).
        writeln("MyDrawingBox constructor");

        this.drawingArea = new MyDrawing();
        BrushTypeComboBoxText brushTypes = new BrushTypeComboBoxText(this.drawingArea);
        packStart(this.drawingArea, true, true, 0); // Adds child to box, packed with reference to the start of box.

        Button colorButton = new Button("Color Dialog", &showColor);
        Button undoButton = new Button(StockID.UNDO, &undoWhiteboard);
        Button saveButton = new Button(StockID.SAVE, &saveWhiteboard);

        HBox hbox = new HBox(false, 4);
        hbox.packStart(new Label("Brush type"), false, false, 2);
        hbox.packStart(brushTypes, false, false, 2);
        hbox.packStart(new Label("Brush size"), false, false, 2);
        hbox.packStart(this.drawingArea.getSpin(), false, false, 2);
        hbox.packStart(colorButton, false, false, 2);
        hbox.packStart(undoButton, false, false, 2);
        hbox.packStart(saveButton, false, false, 2);

        packStart(hbox, false, false, 0); // Adds child to box, packed with reference to the start of box.
    }

    /// Deconstructor.
    ~this()
    {
        writeln("MyDrawingBox destructor");
    }

    // What happens when the coloButton is clicked on by the user.
    private void showColor(Button button)
    {
        if (this.d is null)
        {
            this.d = new MyColorChooserDialog(this.drawingArea);
        }
        this.d.run();
        this.d.hide();
    }

    // What happens when the saveButton is clicked on by the user.
    private void saveWhiteboard(Button button)
    {
        this.drawingArea.saveWhiteboard();
    }

    // What happens when the undoButton is clicked on by the user.
    private void undoWhiteboard(Button button)
    {
        writeln("Undo command on whiteboard");
        this.drawingArea.undoWhiteboard();
    }
}

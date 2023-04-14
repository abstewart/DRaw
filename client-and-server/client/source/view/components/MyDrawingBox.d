module view.components.MyDrawingBox;

// Imports.
private import view.components.MyDrawing;
private import view.components.MyColorChooserDialog;
private import controller.commands.Command;
private import view.components.BrushTypeComboBoxText;

private import gdk.c.types; // GtkWindowPosition.

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

    /// Constructs a MyDrawingBox instance.
public:
    this()
    {
        super(false, 4); // this(bool homogeneous, int spacing).
        this.drawingArea = new MyDrawing();
        BrushTypeComboBoxText brushTypes = new BrushTypeComboBoxText(this.drawingArea);
        packEnd(this.drawingArea, true, true, 0); // Adds child to box, packed with reference to the end of box.

        // Buttons.
        Button colorButton = new Button(StockID.SELECT_COLOR, &showColor, true);
        colorButton.setTooltipText("Select Color");
        Button undoButton = new Button(StockID.UNDO, &undoWhiteboard, true);
        undoButton.setTooltipText("Undo");
        Button saveButton = new Button(StockID.SAVE, &saveWhiteboard, true);
        saveButton.setTooltipText("Save");

        // Hbox is a container that organizes child widgets into a single row.
        HBox hbox = new HBox(false, 4);
        hbox.packStart(new Label("Brush Type"), false, false, 2);
        hbox.packStart(brushTypes, false, false, 2);
        hbox.packStart(new Label("Brush Size"), false, false, 2);
        hbox.packStart(this.drawingArea.getSpin(), false, false, 2);
        hbox.packStart(colorButton, false, false, 2);
        hbox.packStart(undoButton, false, false, 2);
        hbox.packStart(saveButton, false, false, 2);
        packStart(hbox, false, false, 0); // Adds child to box, packed with reference to the start of box.
    }

    /// Deconstructor.
    ~this()
    {
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
        this.drawingArea.undoWhiteboard();
    }
}
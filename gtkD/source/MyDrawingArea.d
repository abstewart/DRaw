// Imports.
private import std.stdio;                               // writeln.

private import MyDrawing : MyDrawing;
private import MyColorChooserDialog : MyColorChooserDialog;

private import gtk.VBox;                                // VBox.
private import gtk.Button;                              // Button.
private import gtk.Label;                               // Label.
private import gtk.ComboBoxText;                        // CombBoxText.
private import gtk.HBox;                                // HBox.

class MyDrawingArea : VBox {
    private:
    MyDrawing drawingArea;
    MyColorChooserDialog d;

    public:
    this() {
        super(false, 4);

        this.drawingArea = new MyDrawing();

        ComboBoxText primOption = new ComboBoxText();
        primOption.appendText("Filled Arc");
        primOption.appendText("Arc");
        primOption.appendText("Line");
        primOption.appendText("Point");
        primOption.appendText("Rectangle");
        primOption.appendText("Filled Rectangle");
        primOption.setActive(0);
        primOption.addOnChanged(&this.drawingArea.onPrimOptionChanged);

        packStart(this.drawingArea, true, true,0);

        Button colorButton = new Button("Color Dialog", &showColor);
        Button undoButton = new Button(StockID.UNDO, &undoWhiteboard);
        Button saveButton = new Button(StockID.SAVE, &saveWhiteboard);

        HBox hbox = new HBox(false, 4);
        hbox.packStart(new Label("Brush type"), false, false, 2);
        hbox.packStart(primOption, false, false, 2);
        hbox.packStart(new Label("Brush size"), false, false, 2);
        hbox.packStart(this.drawingArea.getSpin(), false, false, 2);
        hbox.packStart(colorButton, false, false, 2);
        hbox.packStart(undoButton, false, false, 2);
        hbox.packStart(saveButton, false, false, 2);

        packStart(hbox, false, false, 0);
    }

    protected void showColor(Button button) {
        if (this.d  is  null) {
            this.d = new MyColorChooserDialog(this.drawingArea);
        }
        this.d.run();
        this.d.hide();
    }

    protected void saveWhiteboard(Button button) {
        writeln("Save whiteboard to a file");
        this.drawingArea.saveWhiteboard();
    }

    protected void undoWhiteboard(Button button) {
        writeln("Undo command on whiteboard");
        // TODO
    }
}
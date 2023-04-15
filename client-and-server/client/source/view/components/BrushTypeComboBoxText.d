module view.components.BrushTypeComboBoxText;

private import gtk.ComboBoxText; // CombBoxText.

private import view.components.MyDrawing;

/**
 * Class representing the ComboBoxText that is made up of the brush types.
 */
class BrushTypeComboBoxText : ComboBoxText
{
private:
    string[] brushTypes = [
        "Filled Arc", "Arc", "Line", "Point", "Rectangle", "Filled Rectangle"
    ];
    bool entryOn = false;

public:
    /**
    * Constructs BrushTypeComboBoxText instance.
    * Params:
    *        drawingArea : MyDrawing : the client's drawing surface
    */
    this(MyDrawing drawingArea)
    {
        super(entryOn);

        // Add the brush types to the BrushTypeComboBoxText.
        foreach (brush; brushTypes)
        {
            appendText(brush);
        }

        // Preselect the first item in the drop-down.
        setActive(0);

        // How the widge signal addOnChanged() is harnessed.
        addOnChanged(&drawingArea.onBrushOptionChanged);
    }
}

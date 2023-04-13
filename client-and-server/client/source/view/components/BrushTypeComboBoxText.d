module view.components.BrushTypeComboBoxText;

// Imports.
private import view.components.MyDrawing;

private import gtk.ComboBoxText; // CombBoxText.

/// Class representing the ComboBoxText that is made up of the brush types.
class BrushTypeComboBoxText : ComboBoxText
{
    // Instance variables.
private:
    string[] brushTypes = [
        "Filled Arc", "Arc", "Line", "Point", "Rectangle", "Filled Rectangle"
    ];
    bool entryOn = false;

    /// Constructor.
public:
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

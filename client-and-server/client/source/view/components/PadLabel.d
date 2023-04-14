module view.components.PadLabel;

// Imports.
private import view.components.HPadBox : HPadBox;
private import controller.BoxJustify;

private import gtk.Label; // Label.

/// Class used in ConnectGrid. Class representing the label for an entry in a ConnectGrid.
class PadLabel : HPadBox
{
    // Instance variable.
private:
    Label label;

    /**
    * Constructs a PadEntry instnace.
    * Params:
    *        pJustify = the alignment of the widget
    *        text = the label text
    */
public:
    this(BoxJustify pJustify, string text = null)
    {
        this.label = new Label(text);
        super(this.label, pJustify);
    }

    /// Deconstructor.
    ~this()
    {
    }
}
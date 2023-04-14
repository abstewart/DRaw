module view.components.PadEntry;

// Imports.
private import view.components.HPadBox : HPadBox;
private import controller.BoxJustify;

private import gtk.Entry; // Entry.

/// Class used in ConnectGrid. Class representing the entry in a ConnectGrid.
class PadEntry : HPadBox
{
    // Instance variables.
private:
    Entry _entry;
    string _placeholderText;

    /**
    * Constructs a PadEntry instnace.
    * Params:
    *        pJustify = the alignment of the widget
    *        placeholderText = the default text in the entry
    */
public:
    this(BoxJustify pJustify, string placeholderText = null)
    {
        if (placeholderText !is null)
        {
            this._placeholderText = placeholderText;
        }
        else
        {
            this._placeholderText = "";
        }

        this._entry = new Entry(_placeholderText);

        super(this._entry, pJustify);
    }

    /// Deconstructor.
    ~this()
    {
    }

    // Setter method -- sets the visibilty of the entry widget.
    // Sets whether the contents of the entry are visible or not. When visibility is set to FALSE,
    // characters are displayed as the invisible char, and will also appear that way when the text
    // in the entry widget is copied elsewhere.
    private void setVisibility(bool state)
    {
        this._entry.setVisibility(state);
    }

    /// Setter method -- changes the size request of the entry to be about the right size for 'width' characters.
    public void setWidthInCharacters(int width)
    {
        this._entry.setWidthChars(width);
    }

    /// Getter method -- gets the contents of the entry widget.
    public string getText()
    {
        return this._entry.getText();
    }
}
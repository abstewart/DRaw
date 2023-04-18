module view.components.PadEntry;

private import gtk.Entry;

private import view.components.HPadBox : HPadBox;
private import view.components.BoxJustify;

/**
 * Class used in ConnectGrid. Class representing the entry in a ConnectGrid.
 */
class PadEntry : HPadBox
{
private:
    Entry _entry;
    string _placeholderText;

public:
    /**
    * Constructs a PadEntry instance.
    * Params:
    *        pJustify = the alignment of the widget
    *        placeholderText = the default text in the entry
    */
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

    /**
     * Sets whether the contents of the entry are visible or not. When visibility is set to FALSE,
     * characters are displayed as the invisible char, and will also appear that way when the text
     * in the entry widget is copied elsewhere.
     */
    private void setVisibility(bool state)
    {
        this._entry.setVisibility(state);
    }

    /** 
     * Sets the size request of the entry to be about the right size for 'width' characters.
     */
    public void setWidthInCharacters(int width)
    {
        this._entry.setWidthChars(width);
    }

    /** 
     * Gets the contents of the entry widget.
     *
     * Returns:
     *        - text : string : the contents of the entry widget
     */
    public string getText()
    {
        return this._entry.getText();
    }
}

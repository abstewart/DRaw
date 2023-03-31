// Imports.
private import std.stdio;                                               // writeln.

private import HPadBox : HPadBox;
private import BoxJustify : BoxJustify;

private import gtk.Entry;                                               // Entry.

class PadEntry : HPadBox {
    private:
    Entry _entry;
    string _placeholderText;

    public:
    this(BoxJustify pJustify, string placeholderText = null) {
        if (placeholderText !is null) {
            this._placeholderText = placeholderText;
        } else {
            this._placeholderText = "";
        }

        this._entry = new Entry(_placeholderText);

        super(this._entry, pJustify);
    }

    ~this(){
        writeln("PadEntry destructor");
    }

    protected void setVisibility(bool state) {
        this._entry.setVisibility(state);
    }

    public void setWidthInCharacters(int width) {
        this._entry.setWidthChars(width);
    }

    public string getText() {
        return (this._entry.getText());
    }
}
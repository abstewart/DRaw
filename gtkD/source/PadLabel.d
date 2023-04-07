module padLabel;

// Imports.
private import std.stdio;                                               // writeln.

private import HPadBox : HPadBox;
private import BoxJustify : BoxJustify;

private import gtk.Label;                                               // Label.

/// Class used in ConnectGrid. Class representing the label for an entry in a ConnectGrid.
class PadLabel : HPadBox {
    // Instance variable.
    private:
    Label label;

    /// Constructor.
    public:
    this(BoxJustify pJustify, string text = null) {
        writeln("PadLabel constructor");
        this.label = new Label(text);
        super(this.label, pJustify);
    }

    /// Deconstructor.
    ~this(){
        writeln("PadLabel destructor");
    }
}
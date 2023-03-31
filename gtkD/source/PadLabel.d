// Imports.
private import std.stdio;                                               // writeln.

private import HPadBox : HPadBox;
private import BoxJustify : BoxJustify;

private import gtk.Label;                                               // Label.

class PadLabel : HPadBox {
    private:
    Label label;

    public:
    this(BoxJustify pJustify, string text = null) {
        this.label = new Label(text);
        super(this.label, pJustify);
    }

    ~this(){
        writeln("PadLabel destructor");
    }
}
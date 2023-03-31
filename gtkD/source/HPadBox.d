// Imports.
private import std.stdio;                                               // writeln.

private import BoxJustify : BoxJustify;

private import gtk.Box;                                                 // Box.
private import gtk.Widget;                                              // Widget.

class HPadBox : Box {
    private:
    Widget _widget;
    int globalPadding = 0;
    int padding = 0;
    bool fill = false;
    bool expand = false;
    int _borderWidth = 5;
    BoxJustify _pJustify;

    public:
    this(Widget widget, BoxJustify pJustify) {
        this._widget = widget;
        this._pJustify = pJustify;

        super(Orientation.HORIZONTAL, this.globalPadding);

        if (this._pJustify == BoxJustify.LEFT) {
            packStart(this._widget, this.expand, this.fill, this.padding);
        } else if (_pJustify == BoxJustify.RIGHT) {
            packEnd(this._widget, this.expand, this.fill, this.padding);
        } else {
            add(this._widget);
        }
        setBorderWidth(this._borderWidth);
    }

    ~this(){
        writeln("HPadBox destructor");
    }
}
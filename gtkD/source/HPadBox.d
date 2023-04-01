// Imports.
private import std.stdio;                                               // writeln.

private import BoxJustify : BoxJustify;

private import gtk.Box;                                                 // Box.
private import gtk.Widget;                                              // Widget.

/// Class used in PadEntry and PadLabel.
class HPadBox : Box {
    // Instance variables.
    private:
    Widget _widget;
    int globalPadding = 0;
    int padding = 0;
    bool fill = false;
    bool expand = false;
    int _borderWidth = 5;
    BoxJustify _pJustify;

    /// Constructor.
    public:
    this(Widget widget, BoxJustify pJustify) {
        this._widget = widget;
        this._pJustify = pJustify;
        super(Orientation.HORIZONTAL, this.globalPadding);

        if (this._pJustify == BoxJustify.LEFT) {
            packStart(this._widget, this.expand, this.fill, this.padding);      // Adds child to box, packed with reference to the start of box.
        } else if (_pJustify == BoxJustify.RIGHT) {
            packEnd(this._widget, this.expand, this.fill, this.padding);        // Adds child to box, packed with reference to the end of box.
        } else {
            add(this._widget);                                                  // Adds widget to container.
        }

        setBorderWidth(this._borderWidth);                                      // Sets the border width of the container. The border width of a container is the amount of space to leave around the outside of the container.
    }

    /// Deconstructor.
    ~this(){
        writeln("HPadBox destructor");
    }
}
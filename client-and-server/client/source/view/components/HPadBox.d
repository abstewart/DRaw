module view.components.HPadBox;

private import gtk.Box; // Box.
private import gtk.Widget; // Widget.

private import view.components.BoxJustify;

/**
 * Class used in PadEntry and PadLabel.
 */
class HPadBox : Box
{
private:
    Widget _widget;
    int globalPadding = 0;
    int padding = 0;
    bool fill = false;
    bool expand = false;
    int _borderWidth = 5;
    BoxJustify _pJustify;

public:
    /**
    * Constructs a HPadBox instance.
    * Params:
    *        widget   : Widget : a widget (an entry in PadEntry and a label in PadLabel)
    *        pJustify : BoxJustify : the alignment of the widget
    */
    this(Widget widget, BoxJustify pJustify)
    {
        this._widget = widget;
        this._pJustify = pJustify;
        super(Orientation.HORIZONTAL, this.globalPadding);

        if (this._pJustify == BoxJustify.LEFT)
        {
            packStart(this._widget, this.expand, this.fill, this.padding); // Adds child to box, packed with reference to the start of box.
        }
        else if (_pJustify == BoxJustify.RIGHT)
        {
            packEnd(this._widget, this.expand, this.fill, this.padding); // Adds child to box, packed with reference to the end of box.
        }
        else
        {
            add(this._widget); // Adds widget to container.
        }

        setBorderWidth(this._borderWidth); // Sets the border width of the container. The border width of a container is the amount of space to leave around the outside of the container.
    }
}

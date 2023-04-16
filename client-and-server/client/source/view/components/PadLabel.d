module view.components.PadLabel;

private import gtk.Label;

private import view.components.HPadBox : HPadBox;
private import view.components.BoxJustify;

/**
 * Class used in ConnectGrid. Class representing the label for an entry in a ConnectGrid.
 */
class PadLabel : HPadBox
{
private:
    Label label;

public:
    /**
    * Constructs a PadEntry instnace.
    * Params:
    *        pJustify : BoxJustify : the alignment of the widget
    *        text     : string : the label text
    */
    this(BoxJustify pJustify, string text = null)
    {
        this.label = new Label(text);
        super(this.label, pJustify);
    }
}

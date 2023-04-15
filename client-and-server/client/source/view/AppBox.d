module view.AppBox;

// Imports.
private import view.components.MyDrawingBox; // MyDrawingBox.

private import gtk.Box; // Box.

/// AppBox used to arrange myDrawingBox using the notion of packing.
class AppBox : Box
{
    // Instance variable.
private:
    MyDrawingBox myDrawingBox;

    /// Constructs an AppBox instance.
public:
    this()
    {
        super(Orientation.VERTICAL, 10);
        this.myDrawingBox = new MyDrawingBox();
        packStart(this.myDrawingBox, true, true, 0); // Adds child to box, packed with reference to the start of box. The child is packed after any other child packed with reference to the start of box.
    }

    /// Descructor.
    ~this()
    {
    }

    /// Getter method -- gets myDrawingBox. Only used for unittests.
    public MyDrawingBox getMyDrawingBox() {
        return this.myDrawingBox;
    }
}

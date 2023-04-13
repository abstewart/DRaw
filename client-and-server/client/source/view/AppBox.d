module view.AppBox;

// Imports.
private import std.stdio; // writeln.

private import view.components.MyDrawingBox; // MyDrawingBox.

private import gtk.Box; // Box.

/// AppBox used to arrange myDrawingBox using the notion of packing.
class AppBox : Box
{
    // Instance variable.
private:
    MyDrawingBox myDrawingArea;

    /// Constructor.
public:
    this()
    {
        super(Orientation.VERTICAL, 10);
        this.myDrawingArea = new MyDrawingBox();
        packStart(this.myDrawingArea, true, true, 0); // Adds child to box, packed with reference to the start of box. The child is packed after any other child packed with reference to the start of box.
    }

    /// Descructor.
    ~this()
    {
        writeln("AppBox destructor");
    }
}

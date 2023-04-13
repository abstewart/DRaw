module view.components.ChatBox;
// Imports.
private import std.stdio; // writeln.

private import view.components.MyChatBox;
private import view.ApplicationWindow;

private import gtk.Box; // Box.

/// ChatBox used to arrange myDrawingBox using the notion of packing.
class ChatBox : Box
{
    // Instance variable.
private:
    MyChatBox myChatBox;

    /// Constructor.
public:
    this(MyWindow myWindow, string username)
    {
        super(Orientation.VERTICAL, 10);
        this.myChatBox = new MyChatBox(myWindow, username);
        packStart(this.myChatBox, true, true, 0); // Adds child to box, packed with reference to the start of box. The child is packed after any other child packed with reference to the start of box.
    }

    /// Descructor.
    ~this()
    {
    }

    /// Getter method -- gets myChatBox.
    public MyChatBox getMyChatBox()
    {
        return this.myChatBox;
    }
}

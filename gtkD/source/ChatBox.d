// Imports.
private import std.stdio;                               // writeln.

private import MyChatBox : MyChatBox;
private import MyWindow : MyWindow;

private import gtk.Box;                                 // Box.

/// ChatBox used to arrange myDrawingBox using the notion of packing.
class ChatBox : Box {
    // Instance variable.
    private:
    MyChatBox myChatBox;

    /// Constructor.
    public:
    this(MyWindow myWindow) {
        super(Orientation.VERTICAL, 10);
        writeln("ChatBox constructor");
        this.myChatBox = new MyChatBox(myWindow);
        packStart(this.myChatBox, true, true, 0);       // Adds child to box, packed with reference to the start of box. The child is packed after any other child packed with reference to the start of box.
    }

    /// Descructor.
    ~this(){
        writeln("ChatBox destructor");
    }
}
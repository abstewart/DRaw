module view.components.ChatBox;

private import gtk.Box;

private import view.components.MyChatBox;
private import view.MyWindow;

/**
 * ChatBox used to arrange myDrawingBox using the notion of packing.
 */
class ChatBox : Box
{
private:
    MyChatBox myChatBox;

public:
    /**
    * Constructs a ChatBox instnace.
    * Params:
    *        myWindow : MyWindow : the main application window
    *        username : string :  the client's username
    */
    this(MyWindow myWindow, string username)
    {
        super(Orientation.VERTICAL, 10);
        this.myChatBox = new MyChatBox(myWindow, username);
        packStart(this.myChatBox, true, true, 0); // Adds child to box, packed with reference to the start of box. The child is packed after any other child packed with reference to the start of box.
    }

    /**
     * Gets the nested chat box
     *
     * Returns:
     *        - chatbox : MyChatBox : the chatbox gtk object we wrap
     */
    public MyChatBox getMyChatBox()
    {
        return this.myChatBox;
    }
}

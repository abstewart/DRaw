module view.components.MyChatBox;

private import stdlib = core.stdc.stdlib : exit;
private import std.algorithm : equal;
private import std.datetime.systime : SysTime, Clock;
private import std.conv : to;
private import std.typecons;
private import gdk.c.types;
private import gtk.VBox;
private import gtk.Button;
private import gtk.HBox;
private import gtk.ScrolledWindow;
private import gtk.TextView;
private import gtk.TextBuffer;
private import gtk.Label;
private import gtk.MessageDialog;
private import gtk.Dialog;

private import view.MyWindow;
private import model.Communicator;
private import model.Communicator;
private import model.packets.packet;
private import model.ApplicationState;

/**
 * Class representing box the user chats in.
 */
class MyChatBox : VBox
{
private:
    TextView textView1;
    TextBuffer chatBuffer;
    TextBuffer messageBuffer;
    string message;
    MyWindow myWindow;
    string username;

public:
    /**
    * Constructs a MyChatBox instnace.
    * Params:
    *        myWindow : MyWindow :  the main application window
    *        username : string : the client's username
    */
    this(MyWindow myWindow, string username)
    {
        super(false, 4);
        setMarginLeft(20); // Sets the left margin of widget.
        setMarginRight(8); // Sets the right margin of widget.
        setMarginTop(20); // Sets the top margin of widget.
        setMarginBottom(20); // Sets the bottom margin of widget.
        setSizeRequest(300, 500); // Width, height.
        // Store instance variables.
        this.myWindow = myWindow;
        this.username = username;

        // Label for where chat feature.
        Label chatFeatureLabel = new Label("Chat Feature");
        packStart(chatFeatureLabel, false, false, 0);

        // The scroll window for seeing the sent messages.
        ScrolledWindow sw1 = new ScrolledWindow(null, null);
        sw1.setMinContentHeight(400); // Sets the minimum height that scrolled_window should keep visible.
        sw1.setPolicy(PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
        this.textView1 = new TextView();
        this.textView1.setEditable(false);
        this.chatBuffer = this.textView1.getBuffer();
        sw1.add(textView1);
        packStart(sw1, true, true, 0);

        // Label for where to chat.
        Label chatLabel = new Label("Type Your Message Below");
        packStart(chatLabel, false, false, 0);

        // The scroll window for typing a message.
        ScrolledWindow sw2 = new ScrolledWindow(null, null);
        sw2.setMinContentHeight(10); // Sets the minimum height that scrolled_window should keep visible.
        sw2.setPolicy(PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
        TextView textView2 = new TextView();
        textView2.setEditable(true);
        this.messageBuffer = textView2.getBuffer();
        this.messageBuffer.setText("");
        sw2.add(textView2);
        packStart(sw2, true, true, 0);

        // Buttons.
        Button sendButton = new Button("Send Message", (Button button) {
            processSelfChat();
        });
        Button quitButton = new Button(StockID.QUIT, &quitApplication, true);
        quitButton.setTooltipText("Quit");
        HBox hbox = new HBox(false, 4);
        hbox.packStart(sendButton, false, false, 2);
        hbox.packEnd(quitButton, false, false, 2);
        packStart(hbox, false, false, 0); // Adds child to box, packed with reference to the start of box.
    }

    /**
     * Sets the username to be a new username.
     * 
     * Params:
     *       - newUsername : string : the username to set our username to.
     */
    public void setUsername(string newUsername)
    {
        this.username = newUsername;
    }

    /**
     * Handle a chat message from ourselves. This includes sending the message to the server.
     */
    public void processSelfChat()
    {
        if (!this.myWindow.getConnection())
        {
            MessageDialog notConnectedMsg = new MessageDialog(new Dialog(), GtkDialogFlags.MODAL,
                    MessageType.WARNING, ButtonsType.OK,
                    "You are not connected, so you cannot chat.");
            // Sets a position constraint for this window.
            // CENTER_ALWAYS = Keep window centered as it changes size, etc.
            notConnectedMsg.setPosition(GtkWindowPosition.CENTER_ALWAYS);
            notConnectedMsg.run();
            notConnectedMsg.destroy();

            // Clear the text buffer -- even if it is already empty.
            this.messageBuffer.setText("");
            return;
        }
        // We must be connected, so continue.
        this.message = this.messageBuffer.getText();
        // If the bugger is "empty" do not send an empty message.
        if (this.message.equal(""))
        {
            return;
        }

        SysTime currentTime = Clock.currTime();

        // Call chat updater.
        this.updateMessageWindow(this.username, ApplicationState.getClientId(),
                currentTime.stdTime, this.message);

        // Send chat message to server.
        // Username, id, timestamp, message.
        string packetToSend = encodeChatPacket(this.username,
                ApplicationState.getClientId(), currentTime.stdTime, this.message);
        Communicator.queueMessageSend(packetToSend);

        // Clear the text buffer.
        this.messageBuffer.setText("");
    }

    /**
     * Send the message to the chat.
     */
    public void updateMessageWindow(string uname, int cid, long time, string msg)
    {
        // Construct the actual message to display.
        string chat = uname ~ ":" ~ to!string(cid) ~ "; " ~ this.prettyTime(
                time) ~ ":\n\t" ~ msg ~ "\n\n";

        // Add chat message to the chat buffer.
        this.chatBuffer.setText(this.chatBuffer.getText() ~ chat); // Concatenate the new message to the rest of the chatBuffer.

        // ===================================================================================
        // TODO: Look into saving that chatBuffer so when someone connects to the chat after users have sent messages
        // that they have access to all the other messages.
        // ===================================================================================
    }

    /**
    * Send the user connection update status (whether a user has joined or left the chat).
    */
    public void userConnectionUpdate(string uname, int cid, bool connection)
    {
        // Construct the actual update message to display.
        string updateMsg;
        if (connection)
        {
            updateMsg = "\t\t\t\t~~~~" ~ uname ~ ":" ~ to!string(cid) ~ " joined!!!~~~~\n\n";
        }
        else
        {
            updateMsg = "\t\t\t\t~~~~" ~ uname ~ ":" ~ to!string(cid) ~ " left!!!~~~~\n\n";
        }

        // Add update message to the chat buffer.
        this.chatBuffer.setText(this.chatBuffer.getText() ~ updateMsg); // Concatenate the new message to the rest of the chatBuffer.
    }

    /**
    * Handle when you yourself join or leave the chat.
    */
    public void yourConnectionUpdate(string uname, bool connection)
    {
        // Construct the actual update message to display.
        string updateMsg;
        if (connection)
        {
            updateMsg = "\t\t\t\t~~~~" ~ uname ~ " joined!!!~~~~\n\n";
        }
        else
        {
            updateMsg = "\t\t\t\t~~~~" ~ uname ~ " left!!!~~~~\n\n";
        }

        // Add update message to the chat buffer.
        this.chatBuffer.setText(this.chatBuffer.getText() ~ updateMsg); // Concatenate the new message to the rest of the chatBuffer.
    }

    /**
     * Transform a long time into a pretty string version.
     */
    string prettyTime(long numTime)
    {
        SysTime time = SysTime(numTime);
        string amPm = "AM";
        string hour = to!string(time.hour);
        // Check from military time to standard time.
        if (time.hour > 12)
        {
            ubyte h = time.hour % 12;
            hour = to!string(h);
            amPm = "PM";
        }

        string minutes = to!string(time.minute);
        // If there is only 1 digit/character in minutes then you know you need to add a 0.
        if (minutes.length == 1)
        {
            minutes = "0" ~ minutes;
        }
        return (hour ~ ":" ~ minutes ~ amPm);
    }

    /**
     * Get the chat history as 1 giant string.
     */
    public void getChatHistory()
    {
        this.chatBuffer.getText();
    }

    /**
     * Quits the application.
     *
     * Params:
     *       - button : Button : the button to react to
     */
    private void quitApplication(Button button)
    {
        // Disconnect from server, if connected.
        Communicator.disconnect();
        stdlib.exit(0);
    }
}

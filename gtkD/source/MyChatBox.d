// Imports.
private import std.stdio;                               // writeln.
private import stdlib = core.stdc.stdlib : exit;        // exit.
private import std.algorithm;                           // equal.

private import gtk.VBox;                                // VBox.
private import gtk.Button;                              // Button.
private import gtk.HBox;                                // HBox.
private import gtk.ScrolledWindow;                      // ScrolledWindow.
private import gtk.TextView;                            // TextView.
private import gtk.TextBuffer;                          // TextBuffer.
private import gtk.Label;                               // Label.

/// Class representing the user chats in.
class MyChatBox : VBox {
    // Instance variables.
    private:
    TextView textView1;
    TextBuffer chatBuffer;
    TextBuffer messageBuffer;
    string message;
    bool isConnected;

    /// Constructor.
    public:
    this() {
        super(false, 4);
        writeln("MyChatBox constructor");
        this.isConnected = false;

        // Label for where chat feature.
        Label chatFeatureLabel = new Label("Chat Feature");
        packStart(chatFeatureLabel, false, false, 0);

        // The scroll window for seeing the sent messages.
        ScrolledWindow sw1 = new ScrolledWindow(null, null);
        sw1.setPolicy(PolicyType.AUTOMATIC,PolicyType.AUTOMATIC);
        this.textView1 = new TextView();
        this.textView1.setEditable(false);
        this.chatBuffer = this.textView1.getBuffer();
        sw1.add(textView1);
        packStart(sw1, true, true , 0);

        // Label for where to chat.
        Label chatLabel = new Label("Type Your Message Below");
        packStart(chatLabel, false, false, 0);

        // The scroll window for typing a message.
        ScrolledWindow sw2 = new ScrolledWindow(null, null);
        sw2.setPolicy(PolicyType.AUTOMATIC,PolicyType.AUTOMATIC);
        TextView textView2 = new TextView();
        textView2.setEditable(true);
        this.messageBuffer = textView2.getBuffer();
        this.messageBuffer.setText("");
        sw2.add(textView2);
        packStart(sw2, true, true , 0);

        // Buttons.
        Button sendButton = new Button("Send Message", &sendMessage);
        Button quitButton = new Button(StockID.QUIT, &quitApplication);
        HBox hbox = new HBox(false, 4);
        hbox.packStart(sendButton, false, false, 2);
        hbox.packEnd(quitButton, false, false, 2);
        packStart(hbox, false, false, 0);                   // Adds child to box, packed with reference to the start of box.
    }

    /// Deconstructor.
    ~this(){
        writeln("MyChatBox destructor");
    }

    // Send the message to the chat.
    private void sendMessage(Button button) {
        this.message = this.messageBuffer.getText();

        // If the bugger is "empty" do not send an empty message.
        if (this.message.equal("")) {
            writeln("No message to send");
            return;
        }

        writeln("Sent this message: ", this.message);
        // ===================================================================================
        // TODO: Get it to show up in the chat window display.
        // TODO: Add chat window display. Figure out how to how your messages on the right
        // side and others on the left side -- maybe even include who is sending the message
        // and at what time.
        // ===================================================================================
        this.chatBuffer.setText(this.message);

        // ===================================================================================
        // TODO: Send the message over the network to all other clients.
        // ===================================================================================

        // Clear the text buffer.
        this.messageBuffer.setText("");
    }

    // What happens when the user exits the window.
    private void quitApplication(Button button) {
        writeln("Exit program");

        // ===================================================================================
        // TODO: Disconnect from server, if connected.
        // ===================================================================================

        stdlib.exit(0);
    }
}
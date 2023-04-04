// Imports.
private import std.stdio;                               // writeln.
private import stdlib = core.stdc.stdlib : exit;        // exit.

private import gtk.VBox;                                // VBox.
private import gtk.Button;                              // Button.
private import gtk.HBox;                                // HBox.
private import gtk.ScrolledWindow;                      // ScrolledWindow.
private import gtk.TextView;                            // TextView.
private import gtk.TextBuffer;                          // TextBuffer.

/// Class representing the user chats in.
class MyChatBox : VBox {
    // Instance variable.
    private:
    TextBuffer textBuffer;

    /// Constructor.
    public:
    this() {
        super(false, 4);

        ScrolledWindow sw = new ScrolledWindow(null, null);
        sw.setPolicy(PolicyType.AUTOMATIC,PolicyType.AUTOMATIC);

        TextView textView = new TextView();
        this.textBuffer = textView.getBuffer();
        this.textBuffer.setText("");

        sw.add(textView);
        packStart(sw, true, true ,0);

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
        writeln("Send chat message");
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
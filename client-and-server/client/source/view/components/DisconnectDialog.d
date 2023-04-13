module view.components.DisconnectDialog;

// Imports.
private import std.stdio; // writeln.
private import std.socket; // socket.

private import view.MyWindow;

private import gdk.c.types; // GtkWindowPosition.

private import gtk.Dialog; // Dialog.
private import gtk.MessageDialog; // MessageDialog.

/// Class representing what opens when the user clicks the Disconnect button.
class DisconnectDialog : Dialog
{
    // Instance variables.
private:
    DialogFlags flags = DialogFlags.MODAL;
    ResponseType[] responseTypes = [ResponseType.YES, ResponseType.NO];
    string[] buttonLabels = ["Yes", "No"];
    string titleText = "Disconnect?";
    MyWindow myWindow;
    bool isConnected;

    /// Constructor.
public:
    this(MyWindow myWindow)
    {
        super(this.titleText, null, this.flags, this.buttonLabels, this.responseTypes);
        writeln("Disconnect constructor");
        // Sets a position constraint for this window.
        // CENTER_ALWAYS = Keep window centered as it changes size, etc.
        setPosition(GtkWindowPosition.CENTER_ALWAYS);
        this.myWindow = myWindow;
        this.isConnected = this.myWindow.getConnection();
        writeln("In connection. isConnected = ", this.isConnected);
        addOnResponse(&doSomething); // Emitted when an action widget is clicked, the dialog receives a delete event, or the application programmer calls Dialog.response.
        run(); // Blocks in a recursive main loop until the dialog either emits the response signal, or is destroyed.
        destroy();
    }

    /// Deconstructor.
    ~this()
    {
        writeln("Disconnect destructor");
    }

    // React based on which response the user picked.
    private void doSomething(int response, Dialog d)
    {
        switch (response)
        {
        case ResponseType.YES:
            // If they are not connected -- alert them that they are already not connected.
            if (!this.isConnected)
            {
                MessageDialog message = new MessageDialog(this, GtkDialogFlags.MODAL,
                        MessageType.INFO, ButtonsType.OK,
                        "You are were not connected to begin with.");
                message.run();
                message.destroy();
                break;
            }

            // ===================================================================================
            // TODO: If they are connected, disconnect them.
            // this.socket.close();
            // ===================================================================================

            this.myWindow.setConnection(false); // Let myWindow know you are no longer connected.

            MessageDialog message = new MessageDialog(this, GtkDialogFlags.MODAL,
                    MessageType.INFO, ButtonsType.OK, "You are now disconnceted!");
            message.run();
            message.destroy();
            break;
        case ResponseType.NO:
            writeln("You did not disconnect.");
            break;
        default:
            writeln("Dialog closed.");
            break;
        }
    }
}

module view.components.DisconnectDialog;

private import gdk.c.types;
private import gtk.Dialog;
private import gtk.MessageDialog;

private import model.Communicator;
private import view.MyWindow;

/**
 * Class representing what opens when the user clicks the Disconnect button.
 */
class DisconnectDialog : Dialog
{
private:
    DialogFlags flags = DialogFlags.MODAL;
    ResponseType[] responseTypes = [ResponseType.YES, ResponseType.NO];
    string[] buttonLabels = ["Yes", "No"];
    string titleText = "Disconnect?";
    MyWindow myWindow;
    bool isConnected;

public:
    /**
    * Constructs a DisconnectDialog instnace.
    * Params:
    *        myWindow : MyWindow : the main application window
    */
    this(MyWindow myWindow)
    {
        super(this.titleText, null, this.flags, this.buttonLabels, this.responseTypes);
        // Sets a position constraint for this window.
        // CENTER_ALWAYS = Keep window centered as it changes size, etc.
        setPosition(GtkWindowPosition.CENTER_ALWAYS);
        this.myWindow = myWindow;
        this.isConnected = this.myWindow.getConnection();
        addOnResponse(&handleResponse); // Emitted when an action widget is clicked, the dialog receives a delete event, or the application programmer calls Dialog.response.
        run(); // Blocks in a recursive main loop until the dialog either emits the response signal, or is destroyed.
        destroy();
    }

    /**
     * Executes the control flow depending on the option the user selected within the dialogue.
     *
     * Params:
     *       - response : int : represents which dialogue option the user chose
     *       - d        : Dialogue : the dialogue object
     */
    private void handleResponse(int response, Dialog d)
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

            this.myWindow.setConnection(false); // Let myWindow know you are no longer connected.
            this.myWindow.getChatBox.getMyChatBox().yourConnectionUpdate("You", false);
            Communicator.disconnect();

            MessageDialog message = new MessageDialog(this, GtkDialogFlags.MODAL,
                    MessageType.INFO, ButtonsType.OK, "You are now disconnceted!");
            message.run();
            message.destroy();
            break;
        case ResponseType.NO:
            break;
        default:
            break;
        }
    }
}

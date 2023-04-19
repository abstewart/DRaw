module view.components.ConnectDialog;

private import std.conv;
private import std.typecons;
private import gdk.c.types;
private import gtk.Dialog;
private import gtk.Box;
private import gtk.MessageDialog;

private import model.Communicator;
private import view.components.AreaContent;
private import view.MyWindow;
private import model.ApplicationState;
private import controller.commands.Command;
private import util.Validator;

/**
 * Class representing what opens when the user clicks the Connect button. 
 * Provides functionality for entering a username, ip address and port.
 * Routes clicks to their appropriate functions.
 */
class ConnectDialog : Dialog
{
    // (https://gtkdcoding.com/2019/06/14/0044-custom-dialog-iii.html)
private:
    GtkDialogFlags flags = GtkDialogFlags.MODAL;
    MessageType messageType = MessageType.INFO;
    string[] buttonLabels = ["OK", "Cancel"];
    int responseID;
    ResponseType[] responseTypes = [ResponseType.OK, ResponseType.CANCEL];
    string messageText = "";
    string titleText = "Connect";
    Box contentArea;
    AreaContent areaContent;
    MyWindow myWindow;
    bool isConnected;
    string username;

public:
    /**
    * Constructs a ConnectDialog instance.
    * Params:
    *        - myWindow = the main application window
    */
    this(MyWindow myWindow)
    {
        super(titleText, null, this.flags, this.buttonLabels, this.responseTypes);
        // Sets a position constraint for this window.
        // CENTER_ALWAYS = Keep window centered as it changes size, etc.
        setPosition(GtkWindowPosition.CENTER_ALWAYS);
        this.myWindow = myWindow;
        this.isConnected = this.myWindow.getConnection();
        this.username = ""; // Initially the username is set to an empty string.
        farmOutContent();
        addOnResponse(&handleResponse); // Emitted when an action widget is clicked, the dialog receives a delete event, or the application programmer calls Dialog.response.
        run(); // Blocks in a recursive main loop until the dialog either emits the response signal, or is destroyed.
        destroy();
    }

    /**
     * Gets the username this component holds.
     *
     * Returns:
     *        - username : string : the username this component holds
     */
    public string getUsername()
    {
        return this.username;
    }

    /**
     * FARMS out content area to area content.
     */
    private void farmOutContent()
    {
        this.contentArea = getContentArea();
        this.areaContent = new AreaContent(this.contentArea);
    }

    /**
     * Given a username, ip address and port, will attempt to instantiate a Communicator object.
     *
     * Params:
     *       - username : string : the username to connect with
     *       - ipAddr   : string : the ip address to connect to
     *       - port     : ushort : the port number to connect to
     */
    private void attemptConnection(string username, string ipAddr, ushort port)
    {
        //clear the drawing board and command history prior to attempting to connect
        this.myWindow.getAppBox().getMyDrawingBox().getMyDrawing().clearDrawing();
        Tuple!(string, int, Command)[] history = [];
        ApplicationState.setCommandHistory(history);
        // Get the communicator. If the communicator is null, it will be created.
        // Creating the communicator, encodes and sends to the server a connection packet.
        Communicator.getCommunicator(port, ipAddr, username);
        bool connected = Communicator.getConnectionStatus();
        this.myWindow.setConnection(connected);
        this.myWindow.setUsername(username);
        MessageDialog message = connected ? new MessageDialog(this, GtkDialogFlags.MODAL,
                MessageType.INFO, ButtonsType.OK, "You are now connceted!") : new MessageDialog(this,
                GtkDialogFlags.MODAL,
                MessageType.INFO, ButtonsType.OK, "Connection failed, please try again.");
        message.run();
        message.destroy();

        if (connected)
        {
            this.myWindow.getChatBox.getMyChatBox().yourConnectionUpdate(username, connected);
        }
    }

    /**
     * Executes the control flow depending on the option the user selected within the dialog.
     *
     * Params:
     *       - response : int : represents which dialogue option the user chose
     *       - d        : Dialogue : the dialogue object
     */
    private void handleResponse(int response, Dialog d)
    {
        switch (response)
        {
        case ResponseType.OK:
            string ipAddr = this.areaContent.getConnectGrid.getData()[1];
            string uname = this.areaContent.getConnectGrid.getData()[0];
            string port = this.areaContent.getConnectGrid.getData()[2];
            if (this.isConnected)
            {
                MessageDialog alreadyConnectedMsg = new MessageDialog(this, GtkDialogFlags.MODAL, MessageType.WARNING, ButtonsType
                        .OK, "You are already connected. If you would like to connect to a different IP adddress and/or port, please disconnect first.");
                alreadyConnectedMsg.run();
                alreadyConnectedMsg.destroy();
                return;
            }
            if (Validator.isValidUsername(uname)
                    && Validator.isValidPort(port) && Validator.isValidIPAddress(ipAddr))
            {
                this.username = uname;
                attemptConnection(this.username, ipAddr, to!ushort(port));
            }
            else
            {
                MessageDialog messageWarning = new MessageDialog(this, GtkDialogFlags.MODAL, MessageType.WARNING, ButtonsType
                        .OK, "You either typed in an invalid IP address, port number, or username." ~ " Please try again. Port numbers under 1024 are reserved for system services http, ftp, etc." ~ " and thus are considered invalid. Usernames must be at least one alphabetic or numeric character long," ~ " and they cannot contain leading or trailing white space.");
                messageWarning.run();
                messageWarning.destroy();
            }
            break;
        case ResponseType.CANCEL:
            break;
        default:
            break;
        }
    }
}

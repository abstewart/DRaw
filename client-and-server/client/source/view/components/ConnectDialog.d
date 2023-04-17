module view.components.ConnectDialog;

private import std.conv;
private import std.string : isNumeric;
private import std.algorithm.comparison : equal;
private import std.regex;
private import gdk.c.types;
private import gtk.Dialog;
private import gtk.Box;
private import gtk.MessageDialog;

private import model.Communicator;
private import view.components.AreaContent;
private import view.MyWindow;

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
    * Constructs a ConnectDialog instnace.
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
        Communicator.getCommunicator(port, ipAddr, username);
        bool connected = Communicator.getConnectionStatus();
        this.myWindow.setConnection(connected);
        MessageDialog message = connected ? new MessageDialog(this, GtkDialogFlags.MODAL,
                MessageType.INFO, ButtonsType.OK, "You are now connceted!") : new MessageDialog(this,
                GtkDialogFlags.MODAL,
                MessageType.INFO, ButtonsType.OK, "Connection failed, please try again");
        message.run();
        message.destroy();

        if (connected)
        {
            this.myWindow.getChatBox.getMyChatBox().yourConnectionUpdate("You", connected);
        }
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
            if (isValidUsername(uname) && isValidPort(port) && isValidIPAddress(ipAddr))
            {
                this.username = uname;
                attemptConnection(this.username, ipAddr, to!ushort(port));
            }
            else
            {
                MessageDialog messageWarning = new MessageDialog(this, GtkDialogFlags.MODAL, MessageType.WARNING, ButtonsType
                        .OK, "You either typed in an invalid IP address, port number, or username." ~ " Please try again. Port numbers under 1024 are reserved for system services http, ftp, etc." ~ " and thus are considered invalid. Usernames must be at least one alphebtic or numeric character long," ~ " and they cannot contain leading or trailing white space.");
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

    /**
     * Validates the given username.
     *
     * A username is valid if it has at least one letter or number and no trailing whitespace.
     *
     * Params:
     *       - username : string : the username to validate
     *
     * Returns:
     *       - status : bool : true if the username is valid, false if not
     */
    private bool isValidUsername(string username)
    {
        // (https://stackoverflow.com/questions/34974942/regex-for-no-whitespace-at-the-beginning-and-end)
        // Regular expression that prevents symbols and only allows letters and numbers.
        // Allows for spaces between words. But there cannot be any leading or trailing spaces.
        auto r = regex(r"^[-a-zA-Z0-9-()]+(\s+[-a-zA-Z0-9-()]+)*$");
        return !username.equal("") && matchFirst(username, r);
    }

    /** 
     * Validates the given IP address.
     *
     * An IP address is valid if it is in IPv4 dotted-decimal form a.b.c.d where 0 <= a,b,c,d <= 255
     * or if IP address is a hostname that will resolve.
     *
     * Params: 
     *       - ipAddress : string : the IP address to validate
     *
     * Returns:
     *       - status : bool : true if the IP address is valid, false if not
     */
    private bool isValidIPAddress(string ipAddress)
    {
        // Regex expression for validating IPv4. (https://ihateregex.io/expr/ip/)
        auto r4 = regex(
                r"(\b25[0-5]|\b2[0-4][0-9]|\b[01]?[0-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}");
        return ipAddress.equal("localhost") || matchFirst(ipAddress, r4);
    }

    /**
     * Validates the given port.
     *
     * A valid port is any port that is not reserved (1-1024) and is a valid port number (1-65535).
     *
     * Params:
     *       - port : string : the port number to check
     * 
     * Returns:
     *       - status : bool : true if the port is valid, false if not
     */
    private bool isValidPort(string port)
    {
        const ushort LOWRANGE = 1;
        const ushort SYSPORT = 1024;
        if (isNumeric(port))
        {
            try
            {
                ushort portNum = to!ushort(port);
                // Do not need to check for the high range of 65535 because to!ushort will handle that for us.
                if (portNum < LOWRANGE)
                {
                    return false;
                }
                if (portNum <= SYSPORT)
                {
                    return false;
                }
            }
            catch (ConvException ce)
            {
                return false;
            }

            return true;
        }
        return false;
    }
}

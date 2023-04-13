module view.components.ConnectDialog;

// Imports.
private import std.stdio; // writeln.
private import std.conv; // to.
private import std.socket; // socket.
private import std.conv; // to.
private import std.string; // isNumeric.
private import std.algorithm.comparison : equal; // equal.
private import std.regex; // Regular expressions.

private import view.components.AreaContent;
private import view.MyWindow;

private import gdk.c.types; // GtkWindowPosition.

private import gtk.Dialog; // Dialog.
private import gtk.Box; // Box.
private import gtk.MessageDialog; // MessageDialog.
private import model.Communicator;
// private import model.network.

/// Class representing what opens when the user clicks the Connect button. The username has to be at least one character long (technically this means a space or new line character, for example, count) -- does not have to be unique from other users' usernames -- no way of checking for that in this version of the application.
// (https://gtkdcoding.com/2019/06/14/0044-custom-dialog-iii.html)
class ConnectDialog : Dialog
{
    // Instance variables.
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

    /// Constructor.
public:
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
        addOnResponse(&handleClick); // Emitted when an action widget is clicked, the dialog receives a delete event, or the application programmer calls Dialog.response.
        run(); // Blocks in a recursive main loop until the dialog either emits the response signal, or is destroyed.
        destroy();
    }

    /// Deconstructor.
    ~this()
    {
    }

    /// Getter method -- gets the username the user typed in.
    public string getUsername()
    {
        return this.username;
    }

    // FARM it out to AreaContent class.
    private void farmOutContent()
    {
        this.contentArea = getContentArea();
        this.areaContent = new AreaContent(this.contentArea);
    }

    private void attemptConnection(string username, string ipAddr, ushort port) {
        Communicator.getCommunicator(port, ipAddr, username);
        this.myWindow.setConnection(true);
        MessageDialog message = new MessageDialog(this, GtkDialogFlags.MODAL,
                MessageType.INFO, ButtonsType.OK, "You are now connceted!");
        message.run();
        message.destroy();
    }

    // React based on which response the user picked.
    private void handleClick(int response, Dialog d)
    {
        switch (response) {
            case ResponseType.OK:
                string ipAddr = this.areaContent.getConnectGrid.getData()[0];
                string uname = this.areaContent.getConnectGrid.getData()[2];
                string port = this.areaContent.getConnectGrid.getData()[1];
                if (this.isConnected) {
                    MessageDialog alreadyConnectedMsg = new MessageDialog(this, GtkDialogFlags.MODAL, MessageType.WARNING, ButtonsType
                            .OK, "You are already connected. If you would like to connect to a different IP adddress and/or port, please disconnect first.");
                    alreadyConnectedMsg.run();
                    alreadyConnectedMsg.destroy();
                    return;
                }
                if (isValidUsername(uname) && isValidPort(port) && isIPAddress(ipAddr)) {
                    this.username = uname;
                    attemptConnection(this.username, ipAddr, to!ushort(port));
                } else {
                    MessageDialog messageWarning = new MessageDialog(this, GtkDialogFlags.MODAL, MessageType.WARNING, ButtonsType
                    .OK, "You either typed in an invalid IP address, port number, or username." ~ " Please try again. Port numbers under 1024 are reserved for system services http, ftp, etc." ~ " and thus are considered invalid. Usernames must be at least one alphebtic or numeric character long," ~ " and they cannot contain leading or trailing white space.");
                    messageWarning.run();
                    messageWarning.destroy();
                }
                break;
            case ResponseType.CANCEL:
                writeln("clicked cancel connection button");
                break;
            default:
                break;
        }
    }

    // Check for a valid username. A username has to have at least one character. It cannot have
    // any leading or trailing white space. And the character(s) must be either a letter or number.
    // Spaces in between words are accepted.
    // (https://stackoverflow.com/questions/34974942/regex-for-no-whitespace-at-the-beginning-and-end)
    private bool isValidUsername(string username)
    {
        // Regular expression that prevents symbols and only allows letters and numbers.
        // Allows for spaces between words. But there cannot be any leading or trailing spaces.
        auto r = regex(r"^[-a-zA-Z0-9-()]+(\s+[-a-zA-Z0-9-()]+)*$");
        return !username.equal("") && matchFirst(username, r);
    }

    // Check for a valid IP address (IPv4 (Internet Protocol version 4)).
    // Format: an IPv4 address string in the dotted-decimal form a.b.c.d,
    // or a host name which will be resolved using an InternetHost object.
    // where a, b, c, d are in the range 0-255, inclusive. (Example IPv4: 192.168.0.5)
    private bool isValidIPAddress(string ipAddress)
    {
        // Regex expression for validating IPv4. (https://ihateregex.io/expr/ip/)
        auto r4 = regex(
                r"(\b25[0-5]|\b2[0-4][0-9]|\b[01]?[0-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}");
        return ipAddress.equal("localhost") || matchFirst(ipAddress, r4);
    }

    // Check to see if a port number is valid -- reserved ports are considered invalid.
    // A port number is an unsigned short from 1-65535.
    // Port numbers under 1024 are reserved for system services http, ftp, etc.
    private bool isValidPort(string port)
    {
        const ushort LOWRANGE = 1;
        const ushort SYSPORT = 1024;
        if (isNumeric(port))
        {
            try
            {
                ushort portNum = to!ushort(port);
                // Do not need to check fo the high range of 65535 because to!ushort will handle that for us.
                if (portNum < LOWRANGE)
                {
                    writeln("port number is not in the valid range");
                    return false;
                }
                if (portNum <= SYSPORT)
                {
                    writeln("port number cannot be a port reserved for system services");
                    return false;
                }
            }
            catch (ConvException ce)
            {
                writeln("port cannot be converted to a ushort");
                return false;
            }

            return true;
        }
        writeln("port is not a number");
        return false;
    }
}

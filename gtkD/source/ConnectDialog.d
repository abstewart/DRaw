// Imports.
private import std.stdio;                                               // writeln.
private import std.conv;                                                // to.
private import std.socket;                                              // socket.
private import std.conv;                                                // to.
private import std.string;                                              // isNumeric.
private import std.algorithm.comparison : equal;                        // equal.
private import std.regex;                                               // Regular expressions.

private import AreaContent : AreaContent;

private import gtk.Dialog;                                              // Dialog.
private import gtk.Box;                                                 // Box.
private import gtk.MessageDialog;                                       // MessageDialog.

/// Class representing what opens when the user clicks the Connect button.
class ConnectDialog : Dialog {
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

    /// Constructor.
    public:
    this() {
        super(titleText, null, this.flags, this.buttonLabels, this.responseTypes);
        farmOutContent();
        addOnResponse(&doSomething);        // Emitted when an action widget is clicked, the dialog receives a delete event, or the application programmer calls Dialog.response.
        run();                              // Blocks in a recursive main loop until the dialog either emits the response signal, or is destroyed.
        destroy();
    }

    /// Deconstructor.
    ~this(){
        writeln("ConnectDialog destructor");
    }

    // FARM it out to AreaContent class.
    private void farmOutContent() {
        this.contentArea = getContentArea();
        this.areaContent = new AreaContent(this.contentArea);
    }

    // React based on which response the user picked.
    private void doSomething(int response, Dialog d) {
        bool everythingIsValid = true;


        // ===================================================================================
        // TODO: Use the ipAddress and portNum to actually connect to the network.
        string ipAddress;
        ushort portNum;

        // ===================================================================================

        switch (response) {
            case ResponseType.OK:
            foreach (item; this.areaContent.getConnectGrid.getData()) {
                writeln("data item: ", item);
            }

            ipAddress = this.areaContent.getConnectGrid.getData()[0];
            writeln("ipAddress = ", ipAddress);
            if (isIPAddress(ipAddress)) {
                writeln("Is a valid IP address");
            } else {
                writeln("Is not a valid IP address");
                everythingIsValid = false;
                break;      // We can break here, because we don't need to check the port number if the IP address is invalid.
            }

            string portString = this.areaContent.getConnectGrid.getData()[1];
            writeln("portString = ", portString);
            if (isValidPort(portString)) {
                writeln("Is a valid port number");
                // Since it is a valid port number, set it to portNum variable.
                portNum = to!ushort(this.areaContent.getConnectGrid.getData()[1]);


                // ===================================================================================
                // TODO: Check to see if the valid port number is free to use.
                // https://dlang.org/library/std/socket/socket.get_error_text.html
                // this.socket.getErrorText();
                // ===================================================================================


            } else {
                writeln("Is not a port number");
                everythingIsValid = false;
            }
            break ;
            case ResponseType.CANCEL:
            writeln("Cancelled connection");
            break ;
            default:
            writeln("Dialog closed");
            break ;
        }

        if (!everythingIsValid) {
            MessageDialog messageWarning = new MessageDialog(this,
            GtkDialogFlags.MODAL, MessageType.WARNING,
            ButtonsType.OK, "You either typed in an invalid IP address, port number, or both." ~
            " Please try to connect again. Port numbers under 1024 are reserved for system services http, ftp, etc." ~
            " and thus are considered invalid.");
            messageWarning.run();
            messageWarning.destroy();
        } else {
            MessageDialog message = new MessageDialog( this, GtkDialogFlags.MODAL, MessageType.INFO,
            ButtonsType.OK, "You are now connceted!");
            message.run();
            message.destroy();
        }
    }

    // Check for a valid IP address (IPv4 (Internet Protocol version 4)).
    // Format: an IPv4 address string in the dotted-decimal form a.b.c.d,
    // or a host name which will be resolved using an InternetHost object.
    // where a, b, c, d are in the range 0-255, inclusive. (Example IPv4: 192.168.0.5)
    private bool isIPAddress(string ipAddress) {
        if (ipAddress.equal("localhost")) {
            return true;
        }

        // Regex expression for validating IPv4. (https://ihateregex.io/expr/ip/)
        auto r4 = regex(r"(\b25[0-5]|\b2[0-4][0-9]|\b[01]?[0-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}");
        if (matchFirst(ipAddress, r4)) {
            return true;
        }
        return false;
    }

    // Check to see if a port number is valid -- reserved ports are considered invalid.
    // A port number is an unsigned short from 1-65535.
    // Port numbers under 1024 are reserved for system services http, ftp, etc.
    private bool isValidPort(string port) {
        const ushort LOWRANGE = 1;
        const ushort SYSPORT = 1024;
        if (isNumeric(port)) {
            try {
                ushort portNum = to!ushort(port);
                // Do not need to check fo the high range of 65535 because to!ushort will handle that for us.
                if (portNum < LOWRANGE) {
                    writeln("port number is not in the valid range");
                    return false;
                }
                if (portNum <= SYSPORT) {
                    writeln("port number cannot be a port reserved for system services");
                    return false;
                }
            } catch (ConvException ce) {
                writeln("port cannot be converted to a ushort");
                return false;
            }

            return true;
        }
        writeln("port is not a number");
        return false;
    }
}
// Imports.
private import std.stdio;                                               // writeln.
private import std.conv;                                                // to.
private import std.socket;                                              // socket.
private import std.conv;                                                // to.
private import std.string;                                              // isNumeric.

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
        string ipAddress;
        ushort port;
        switch (response) {
            case ResponseType.OK:
            foreach (item; this.areaContent.getConnectGrid.getData()) {
                writeln("data item: ", item);
            }
            // TODO: Check for valid IP address.
            // 12.2.3.04
            // 12.2.3.4
            // localhost
            // example analogy: Date: 50/2/1997 is in a valid date format, but 50 is not a month.
            ipAddress = this.areaContent.getConnectGrid.getData()[0];
            writeln("ipAddress = ", ipAddress);
            if (isIPAddress(ipAddress)) {
                writeln("Is a valid IP address");
            } else {
                writeln("Is not a valid IP address");
                everythingIsValid = false;
                break;      // We can break here, because we don't need to check the port number if the IP address is invalid.
            }




            // TODO: Check for valid port number.
            string portString = this.areaContent.getConnectGrid.getData()[1];
            writeln("portString = ", port);
            if (isValidPort(portString)) {
                writeln("Is a valid port number");
                // Since it is a valid port number, set it to portNum variable.
                portNum = to!ushort(this.areaContent.getConnectGrid.getData()[1]);
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
            ButtonsType.OK, "You either typed in an invalid IP address, port number, or both. Please try to connect again.");
            messageWarning.run();
            messageWarning.destroy();
        } else {
            MessageDialog message = new MessageDialog( this, GtkDialogFlags.MODAL, MessageType.INFO,
            ButtonsType.OK, "You are now connceted!");
            message.run();
            message.destroy();
        }
    }

    // TODO
    // Check IP address format and check if it is a valid IP address if the format is correct.
    private bool isIPAddress(string ipAddress) {
        return true;
    }

    // TODO: Check to see if the valid port number is free to use.
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
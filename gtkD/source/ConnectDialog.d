// Imports.
private import std.stdio;                                               // writeln.
private import std.conv;                                                // to.
private import std.socket;

private import AreaContent : AreaContent;

private import gtk.Dialog;                                              // Dialog.
private import gtk.Box;                                                 // Box.

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
        switch (response) {
            case ResponseType.OK:
            foreach (item; this.areaContent.getConnectGrid.getData()) {
                writeln("data item: ", item);
            }
            // TODO: Check for valid IP addresse.
            string ipAddress = this.areaContent.getConnectGrid.getData()[0];
            writeln("ipAddress = ", ipAddress);
            if (isIPAddress(ipAddress)) {
                writeln("Is a valid IP address");
            } else {
                writeln("Is not a valid IP address");
            }




            // TODO: Check for valid port number.
            // A port number is an unsigned short from 1-65535.
            // Port numbers under 1024 are reserved for system services http, ftp, etc.
            ushort port = to!ushort(this.areaContent.getConnectGrid.getData()[1]);
            writeln("port = ", port);
            if (isValidPort(port)) {
                writeln("Is a valid port number");
            } else {
                writeln("Is not a port number");
            }




            break ;
            case ResponseType.CANCEL:
            writeln("Cancelled connection");
            break ;
            default:
            writeln("Dialog closed");
            break ;
        }
    }

    // TODO
    private bool isIPAddress(string ipAddress) {
        return true;
    }

    // TODO
    // TODO: Check to see if the valid port number is free to use.
    private bool isValidPort(ushort port) {
        return true;
    }
}
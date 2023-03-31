// Imports.
private import std.stdio;                                               // writeln.

private import AreaContent : AreaContent;

private import gtk.Dialog;                                              // Dialog.
private import gtk.Box;                                                 // Box.

class ConnectDialog : Dialog {
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

    public:
    this() {
        super(titleText, null, this.flags, this.buttonLabels, this.responseTypes);
        farmOutContent();

        addOnResponse(&doSomething);
        run();
        destroy();
    }

    ~this(){
        writeln("ConnectDialog destructor");
    }

    protected void farmOutContent() {
        // FARM it out to AreaContent class.
        this.contentArea = getContentArea();
        this.areaContent = new AreaContent(this.contentArea);
    }

    protected void doSomething(int response, Dialog d) {
        switch (response) {
            case ResponseType.OK:
            foreach (item; this.areaContent.getConnectGrid.getData()) {
                writeln("data item: ", item);
            }
            // TODO: Check for valid IP addresses and port numbers.
            break ;
            case ResponseType.CANCEL:
            writeln("Cancelled");
            break ;
            default:
            writeln("Dialog closed");
            break ;
        }
    }
}
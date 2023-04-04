// Imports.
private import std.stdio;                                               // writeln.
private import std.socket;

private import gtk.Dialog;                                              // Dialog.
private import gtk.MessageDialog;                                       // MessageDialog.

/// Class representing what opens when the user clicks the Disconnect button.
class DisconnectDialog : Dialog {
    // Instance variables.
    private:
    DialogFlags flags = DialogFlags.MODAL;
    ResponseType[] responseTypes = [ResponseType.YES, ResponseType.NO];
    string[] buttonLabels = ["Yes", "No"];
    string titleText = "Disconnect?";

    /// Constructor.
    public:
    this() {
        super(this.titleText, null, this.flags, this.buttonLabels, this.responseTypes);
        addOnResponse(&doSomething);            // Emitted when an action widget is clicked, the dialog receives a delete event, or the application programmer calls Dialog.response.
        run();                                  // Blocks in a recursive main loop until the dialog either emits the response signal, or is destroyed.
        destroy();
    }

    /// Deconstructor.
    ~this(){
        writeln("Disconnect destructor");
    }

    // React based on which response the user picked.
    private void doSomething(int response, Dialog d) {
        switch (response) {
            case ResponseType.YES:
            writeln("You disconnected.");



            // ===================================================================================
            // TODO: If they are not connected -- alert them that they are already not connected.


            // TODO: If they are connected, disconnect them.
            // this.socket.close();
            // ===================================================================================



            MessageDialog message = new MessageDialog( this, GtkDialogFlags.MODAL, MessageType.INFO,
            ButtonsType.OK, "You are now disconnceted!");
            message.run();
            message.destroy();
            break ;
            case ResponseType.NO:
            writeln("You did not disconnect.");
            break ;
            default:
            writeln("Dialog closed.");
            break ;
        }
    }
}
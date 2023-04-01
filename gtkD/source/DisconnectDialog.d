// Imports.
private import std.stdio;                                               // writeln.

private import gtk.Dialog;                                              // Dialog.

class DisconnectDialog : Dialog {
    private:
    DialogFlags flags = DialogFlags.MODAL;
    ResponseType[] responseTypes = [ResponseType.YES, ResponseType.NO];
    string[] buttonLabels = ["Yes", "No"];
    string titleText = "Disconnect?";

    public:
    this() {
        super(this.titleText, null, this.flags, this.buttonLabels, this.responseTypes);
        addOnResponse(&doSomething);
        run();
        destroy();
    }

    ~this(){
        writeln("Disconnect destructor");
    }

    protected void doSomething(int response, Dialog d) {
        switch(response) {
            case ResponseType.YES:
                writeln("You disconnected.");
                // TODO: If they are not connected -- alert them that they are already not connected.
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
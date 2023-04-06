// Imports.
private import std.stdio;                                               // writeln.
private import std.typecons;                                            // Tuple.

private import PadLabel : PadLabel;
private import PadEntry : PadEntry;
private import BoxJustify : BoxJustify;

private import gtk.Label;                                               // Label.
private import gtk.Entry;                                               // Entry.
private import gtk.Grid;                                                // Grid.

/// Class representing the Grid in the ConnectDialog.
class ConnectGrid : Grid {
    // Instance variables.
    private:
    int _borderWidth = 10;        // Keeps the widgets from crowding each other in the grid.
    PadLabel usernameLabel;
    string usernameLabelText = "Chat username:";
    PadEntry usernameEntry;
    string usernamePlaceholderText = "";
    PadLabel ipAddressLabel;
    string ipAddressLabelText = "IP Address:";
    PadEntry ipAddressEntry;
    string ipAddressPlaceholderText = "localhost";
    PadLabel portNumLabel;
    string portNumLabelText = "Port number:";
    PadEntry portNumEntry;
    string portNumPlaceholderText = "50002";
    // Store the user-supplied data so it can be retrieved later.
    string _ipAddress;
    string _portNum;
    string _username;

    /// Constructor.
    public:
    this() {
        super();
        writeln("ConnectGrid constructor");
        setBorderWidth(this._borderWidth);               // Keeps the grid separated from the window edges.

        // Row 0.
        this.usernameLabel = new PadLabel(BoxJustify.RIGHT, this.usernameLabelText);
        attach(this.usernameLabel, 0, 0, 1, 1);

        this.usernameEntry = new PadEntry(BoxJustify.LEFT, this.usernamePlaceholderText);
        this.usernameEntry.setWidthInCharacters(30);
        attach(this.usernameEntry, 1, 0, 2, 1);

        // Row 1.
        this.ipAddressLabel = new PadLabel(BoxJustify.RIGHT, this.ipAddressLabelText);
        attach(this.ipAddressLabel, 0, 1, 1, 1);

        this.ipAddressEntry = new PadEntry(BoxJustify.LEFT, this.ipAddressPlaceholderText);
        this.ipAddressEntry.setWidthInCharacters(30);
        attach(this.ipAddressEntry, 1, 1, 1, 1);

        // Row 2.
        this.portNumLabel = new PadLabel(BoxJustify.RIGHT, this.portNumLabelText);
        attach(this.portNumLabel, 0, 2, 1, 1);

        this.portNumEntry = new PadEntry(BoxJustify.LEFT, this.portNumPlaceholderText);
        this.portNumEntry.setWidthInCharacters(30);
        attach(this.portNumEntry, 1, 2, 1, 1);

        setMarginBottom(7);
    }

    /// Destructor.
    ~this(){
        writeln("ConnectGrid destructor");
    }

    /// Getter method -- get the username, IP Address, and port number the user typed in (or the default).
    public Tuple!(string, string, string) getData() {
        this._username = this.usernameEntry.getText();
        this._ipAddress = this.ipAddressEntry.getText();
        this._portNum = this.portNumEntry.getText();
        return tuple(this._username, this._ipAddress, this._portNum);
    }
}
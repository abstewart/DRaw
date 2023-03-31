// Imports.
private import std.stdio;                                               // writeln.
private import std.typecons;                                            // Tuple.
private import stdlib = core.stdc.stdlib : exit;

private import gio.Application : GioApplication = Application;          // GioApplication.

private import MyDrawingArea : MyDrawingArea;                           // MyDrawingArea.

private import gdk.Pixbuf;                                              // Pixbuf.

private import gtk.Version;                                             // Version.
private import gtk.Application;                                         // Application.
private import gtk.ApplicationWindow;                                   // ApplicationWindow.
private import gtk.AccelGroup;                                          // AccelGroup.
private import gtk.Entry;                                               // Entry.
private import gtk.Box;                                                 // Box.
private import gtk.MenuItem;                                            // MenuItem.
private import gtk.Widget;                                              // Widget.
private import gtk.MenuBar;                                             // MenuBar.
private import gtk.Button;                                              // Button.
private import gtk.VBox;                                                // VBox.
private import gtk.HButtonBox;                                          // HButtonBox.
private import gtk.Statusbar;                                           // Statusbar.
private import gtk.Menu;                                                // Menu.
private import gtk.ButtonBox;                                           // ButtonBox.
private import gtk.Grid;                                                // Grid.
private import gtk.MessageDialog;                                       // MessageDialog.
private import gtk.Label;                                               // Label.
private import gtk.AboutDialog;                                         // AboutDialog.
private import gtk.Dialog;                                              // Dialog.

class MyWindow : ApplicationWindow {
    public:
    this(Application application) {
        super(application);
        setTitle("DRaw");
        setup();
        showAll();

        string versionCompare = Version.checkVersion(3,0,0);

        if (versionCompare.length > 0){
            MessageDialog d = new MessageDialog(this, GtkDialogFlags.MODAL, MessageType.WARNING, ButtonsType.OK,
                                "GtkD : Gtk+ version missmatch\n" ~ versionCompare ~
                                "\nYou might run into problems!"~ "\n\nPress OK to continue");
            d.run();
            d.destroy();
        }
    }

    ~this(){
        writeln("MyWindow destructor");
    }

    protected void setup() {
        VBox mainBox = new VBox(false,0);
        mainBox.packStart(getMenuBar(), false, false,0);

        // AppBox.
        AppBox appBox = new AppBox();
        mainBox.packStart(appBox, false, false,0);

        // Buttons.
        Button connectButton = new Button(StockID.CONNECT, &connectWhiteboard);
        Button disconnectButton = new Button(StockID.DISCONNECT, &disconnectWhiteboard);
        Button quitButton = new Button(StockID.QUIT, &anyButtonExits);
        ButtonBox bBox = HButtonBox.createActionBox();
        bBox.packEnd(connectButton, 0, 0, 10);
        bBox.packEnd(disconnectButton, 0, 0, 10);
        bBox.packEnd(quitButton,0, 0, 10);
        mainBox.packStart(bBox, false, false,0);

        // Statusbar.
        Statusbar statusbar = new Statusbar();
        mainBox.packStart(statusbar, false, true,0);

        // Add mainBox to Window.
        add(mainBox);
    }

    protected void connectWhiteboard(Button button) {
        writeln("Connect whiteboard");
        ConnectDialog connectDialog = new ConnectDialog();
    }

    protected void disconnectWhiteboard(Button button) {
        writeln("Disconnect whiteboard");
        DisconnectDialog disconnectDialog = new DisconnectDialog();
    }

    protected void anyButtonExits(Button button) {
        writeln("Exit program");
        // TODO: Disconnect from server, if connected.
        stdlib.exit(0);
    }

    protected void onMenuActivate(MenuItem menuItem) {
        string action = menuItem.getActionName();
        switch (action) {
            case "help.about":
                GtkDAbout dlg = new GtkDAbout();
                dlg.addOnResponse(&onDialogResponse);
                dlg.showAll();
                dlg.run();
                dlg.destroy();
                break ;
            default:
                MessageDialog d = new MessageDialog(this, GtkDialogFlags.MODAL, MessageType.INFO, ButtonsType.OK,
                                    "You pressed menu item "~action);
                d.run();
                d.destroy();
                break ;
        }
    }

    protected void onDialogResponse(int response, Dialog dlg) {
        if (response == GtkResponseType.CANCEL) {
            dlg.destroy();
        }
    }

    protected MenuBar getMenuBar() {
        AccelGroup accelGroup = new AccelGroup();
        addAccelGroup(accelGroup);
        MenuBar menuBar = new MenuBar();
        Menu menu = menuBar.append("_Help");
        menu.append(new MenuItem(&onMenuActivate, "_About","help.about", true, accelGroup, 'a',
                        GdkModifierType.CONTROL_MASK|GdkModifierType.SHIFT_MASK));
        return menuBar;
    }

    protected int windowDelete(GdkEvent* event, Widget widget) {
        debug(events) {
            writefln("MyWindow.widgetDelete : this and widget to delete %X %X", this, window);
        }

        MessageDialog d = new MessageDialog(this, GtkDialogFlags.MODAL, MessageType.QUESTION,
        ButtonsType.YES_NO, "Are you sure you want to exit?");
        int responce = d.run();
        if (responce == ResponseType.YES){
            // TODO: Disconnect from server, if connected.
            stdlib.exit(0);
        }
        d.destroy();
        return true;
    }

    // Inner classes.

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
                    foreach (item; areaContent.getConnectGrid.getData()) {
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

    class AreaContent {
        private:
        Box _contentArea;
        ConnectGrid _connectGrid;

        public:
        this(Box contentArea) {
            this._contentArea = contentArea;
            this._connectGrid = new ConnectGrid();
            this._contentArea.add(this._connectGrid);
            this._contentArea.showAll();
        }

        ~this(){
            writeln("AreaContent destructor");
        }

        ConnectGrid getConnectGrid() {
            return (this._connectGrid);
        }
    }

    class ConnectGrid : Grid {
        private:
        int _borderWidth = 10;        // Keeps the widgets from crowding each other in the grid.
        PadLabel ipAddressLabel;
        string ipAddressLabelText = "IP Address:";
        PadEntry ipAddressEntry;
        string ipAddressPlaceholderText = "localhost";
        PadLabel portNumLabel;
        string portNumLabelText = "Port number:";
        PadEntry portNumEntry;
        string portNumPlaceholderText = "50001";
        // Store the user-supplied data so it can be retrieved later.
        string _ipAddress;
        string _portNum;

        public:
        this() {
            super();
            setBorderWidth(this._borderWidth);               // Keeps the grid separated from the window edges.

            // Row 0.
            this.ipAddressLabel = new PadLabel(BoxJustify.RIGHT, this.ipAddressLabelText);
            attach(this.ipAddressLabel, 0, 0, 1, 1);

            this.ipAddressEntry = new PadEntry(BoxJustify.LEFT, this.ipAddressPlaceholderText);
            this.ipAddressEntry.setWidthInCharacters(30);
            attach(this.ipAddressEntry, 1, 0, 2, 1);

            // Row 1.
            this.portNumLabel = new PadLabel(BoxJustify.RIGHT, this.portNumLabelText);
            attach(this.portNumLabel, 0, 1, 1, 1);

            this.portNumEntry = new PadEntry(BoxJustify.LEFT, this.portNumPlaceholderText);
            this.portNumEntry.setWidthInCharacters(30);
            attach(this.portNumEntry, 1, 1, 1, 1);

            setMarginBottom(7);
        }

        ~this(){
            writeln("ConnectGrid destructor");
        }

        protected Tuple!(string, string) getData() {
            this._ipAddress = this.ipAddressEntry.getText();
            this._portNum = this.portNumEntry.getText();
            return (tuple(this._ipAddress, this._portNum));
        }
    }

    class PadLabel : HPadBox {
        private:
        Label label;

        public:
        this(BoxJustify pJustify, string text = null) {
            this.label = new Label(text);
            super(this.label, pJustify);
        }

        ~this(){
            writeln("PadLabel destructor");
        }
    }

    class PadEntry : HPadBox {
        private:
        Entry _entry;
        string _placeholderText;

        public:
        this(BoxJustify pJustify, string placeholderText = null) {
            if (placeholderText !is null) {
                this._placeholderText = placeholderText;
            } else {
                this._placeholderText = "";
            }

            this._entry = new Entry(_placeholderText);

            super(this._entry, pJustify);
        }

        ~this(){
            writeln("PadEntry destructor");
        }

        protected void setVisibility(bool state) {
            this._entry.setVisibility(state);
        }

        protected void setWidthInCharacters(int width) {
            this._entry.setWidthChars(width);
        }

        protected string getText() {
            return (this._entry.getText());
        }
    }

    class HPadBox : Box {
        private:
        Widget _widget;
        int globalPadding = 0;
        int padding = 0;
        bool fill = false;
        bool expand = false;
        int _borderWidth = 5;
        BoxJustify _pJustify;

        public:
        this(Widget widget, BoxJustify pJustify) {
            this._widget = widget;
            this._pJustify = pJustify;

            super(Orientation.HORIZONTAL, this.globalPadding);

            if (this._pJustify == BoxJustify.LEFT) {
                packStart(this._widget, this.expand, this.fill, this.padding);
            } else if (_pJustify == BoxJustify.RIGHT) {
                packEnd(this._widget, this.expand, this.fill, this.padding);
            } else {
                add(this._widget);
            }
            setBorderWidth(this._borderWidth);
        }

        ~this(){
            writeln("HPadBox destructor");
        }
    }

    enum BoxJustify {
        LEFT = 0,
        RIGHT = 1,
        CENTER = 2,
    }

    class AppBox : Box {
        private:
        MyDrawingArea myDrawingArea;

        public:
        this() {
            super(Orientation.VERTICAL, 10);
            this.myDrawingArea = new MyDrawingArea();
            packStart(this.myDrawingArea, true, true, 0);
        }

        ~this(){
            writeln("AppBox destructor");
        }
    }

    class GtkDAbout : AboutDialog {
        public:
        this() {
            string itemLabel = "About";
            string sectionName = "Them What Done Stuff";
            string[] people = ["Andrew Briasco-Stewart", "Benjamin Mallett", "Elizabeth Williams", "Steven Abbott"];
            string[] artists = people;
            string[] documenters = people;
            string comments = "This is a gtkD demo -- DRaw.";
            string license = "License Foundations of Software Engineering Spring 2023";
            string programName = "DRaw";
            string protection = "Copywrite 2023 © DRaw";
            string pixbufFilename = "images/logo.png";
            Pixbuf logoPixbuf = new Pixbuf(pixbufFilename);

            setAuthors(people);
            setArtists(artists);
            addCreditSection(sectionName, people);            // Shows when the Credits button is clicked.
            setCopyright(protection);
            setComments(comments);
            setLicense(license);
            setProgramName(programName);
            setLogo(logoPixbuf);
        }

        ~this(){
            writeln("GtkDAbout destructor");
        }
    }
}

int main(string[] args){
    import gtkd.Loader;

    Linker.dumpLoadLibraries();
    Linker.dumpFailedLoads();
    auto application = new Application("demo.MyWindow", GApplicationFlags.FLAGS_NONE);
    application.addOnActivate(delegate void(GioApplication app) {
        new MyWindow(application);
    });
    return application.run(args);
}
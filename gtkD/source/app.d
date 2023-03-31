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
    int windowDelete(GdkEvent* event, Widget widget) {
        debug(events) {
            writefln("MyWindow.widgetDelete : this and widget to delete %X %X",this,window);
        }

        MessageDialog d = new MessageDialog(this, GtkDialogFlags.MODAL, MessageType.QUESTION,
        ButtonsType.YES_NO, "Are you sure you want' to exit?");
        int responce = d.run();
        if (responce == ResponseType.YES){
            stdlib.exit(0);
        }
        d.destroy();
        return true;
    }

    void connectWhiteboard(Button button) {
        writeln("Connect whiteboard");
        NewImageDialog n = new NewImageDialog();
    }

    class NewImageDialog : Dialog {
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
            super(titleText, null, flags, buttonLabels, responseTypes);
            farmOutContent();

            addOnResponse(&doSomething);
            run();
            destroy();
        }

        void farmOutContent() {
            // FARM it out to AreaContent class.
            contentArea = getContentArea();
            areaContent = new AreaContent(contentArea);
        }

        void doSomething(int response, Dialog d) {
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
            _contentArea = contentArea;
            _connectGrid = new ConnectGrid();
            _contentArea.add(_connectGrid);
            _contentArea.showAll();
        }

        ConnectGrid getConnectGrid() {
            return (_connectGrid);
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
            setBorderWidth(_borderWidth); // keeps the grid separated from the window edges

            // Row 0
            ipAddressLabel = new PadLabel(BoxJustify.RIGHT, ipAddressLabelText);
            attach(ipAddressLabel, 0, 0, 1, 1);

            ipAddressEntry = new PadEntry(BoxJustify.LEFT, ipAddressPlaceholderText);
            ipAddressEntry.setWidthInCharacters(30);
            attach(ipAddressEntry, 1, 0, 2, 1);

            // Row 1
            portNumLabel = new PadLabel(BoxJustify.RIGHT, portNumLabelText);
            attach(portNumLabel, 0, 1, 1, 1);

            portNumEntry = new PadEntry(BoxJustify.LEFT, portNumPlaceholderText);
            portNumEntry.setWidthInCharacters(30);
            attach(portNumEntry, 1, 1, 1, 1);

            setMarginBottom(7);
        }

        Tuple!(string, string) getData() {
            _ipAddress = ipAddressEntry.getText();
            _portNum = portNumEntry.getText();
            return (tuple(_ipAddress, _portNum));
        }
    }

    class PadLabel : HPadBox {
        Label label;

        this(BoxJustify pJustify, string text = null) {
            label = new Label(text);
            super(label, pJustify);
        }
    }

    class PadEntry : HPadBox {
        Entry _entry;
        string _placeholderText;

        this(BoxJustify pJustify, string placeholderText = null) {
            if (placeholderText !is null) {
                _placeholderText = placeholderText;
            } else {
                _placeholderText = "";
            }

            _entry = new Entry(_placeholderText);

            super(_entry, pJustify);
        }

        void setVisibility(bool state) {
            _entry.setVisibility(state);
        }

        void setWidthInCharacters(int width) {
            _entry.setWidthChars(width);
        }

        string getText() {
            return (_entry.getText());
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
            _widget = widget;
            _pJustify = pJustify;

            super(Orientation.HORIZONTAL, globalPadding);

            if (_pJustify == BoxJustify.LEFT) {
                packStart(_widget, expand, fill, padding);
            } else if (_pJustify == BoxJustify.RIGHT) {
                packEnd(_widget, expand, fill, padding);
            } else {
                add(_widget);
            }
            setBorderWidth(_borderWidth);
        }
    }

    enum BoxJustify {
        LEFT = 0,
        RIGHT = 1,
        CENTER = 2,
    }

    void anyButtonExits(Button button) {
        writeln("Exit program");
        stdlib.exit(0);
    }

    void saveWhiteboard(Button button) {
        writeln("Save whiteboard to a file");
    }

    void undoWhiteboard(Button button) {
        writeln("Undo command on whiteboard");
    }

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

    void setup() {
        VBox mainBox = new VBox(false,0);
        mainBox.packStart(getMenuBar(), false, false,0);

        // AppBox.
        AppBox appBox = new AppBox();
        mainBox.packStart(appBox, false, false,0);

        // Buttons.
        Button connectButton = new Button(StockID.CONNECT, &connectWhiteboard);
        Button undoButton = new Button(StockID.UNDO, &undoWhiteboard);
        Button saveButton = new Button(StockID.SAVE, &saveWhiteboard);
        Button quitButton = new Button(StockID.QUIT, &anyButtonExits);
        ButtonBox bBox = HButtonBox.createActionBox();
        bBox.packEnd(connectButton, 0, 0, 10);
        bBox.packEnd(undoButton, 0, 0, 10);
        bBox.packEnd(saveButton,0, 0, 10);
        bBox.packEnd(quitButton,0, 0, 10);
        mainBox.packStart(bBox, false, false,0);

        // Statusbar.
        Statusbar statusbar = new Statusbar();
        mainBox.packStart(statusbar, false, true,0);

        // Add mainBox to Window.
        add(mainBox);
    }

    MenuBar getMenuBar() {
        AccelGroup accelGroup = new AccelGroup();
        addAccelGroup(accelGroup);
        MenuBar menuBar = new MenuBar();
        Menu menu = menuBar.append("_Help");
        menu.append(new MenuItem(&onMenuActivate, "_About","help.about", true, accelGroup, 'a',
        GdkModifierType.CONTROL_MASK|GdkModifierType.SHIFT_MASK));
        return menuBar;
    }

    class AppBox : Box {
        MyDrawingArea myDrawingArea;

        this() {
            super(Orientation.VERTICAL, 10);
            myDrawingArea = new MyDrawingArea();
            packStart(myDrawingArea, true, true, 0);
        }
    }

    class GtkDAbout : AboutDialog {
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
    }

    void onMenuActivate(MenuItem menuItem) {
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

    void onDialogResponse(int response, Dialog dlg) {
        if (response == GtkResponseType.CANCEL) {
            dlg.destroy();
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
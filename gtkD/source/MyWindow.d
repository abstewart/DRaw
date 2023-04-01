// Imports.
private import std.stdio;                                               // writeln.
private import stdlib = core.stdc.stdlib : exit;

private import DisconnectDialog : DisconnectDialog;
private import ConnectDialog : ConnectDialog;
private import AppBox : AppBox;
private import GtkDAbout : GtkDAbout;

private import gtk.Version;                                             // Version.
private import gtk.Application;                                         // Application.
private import gtk.ApplicationWindow;                                   // ApplicationWindow.
private import gtk.AccelGroup;                                          // AccelGroup.
private import gtk.MenuItem;                                            // MenuItem.
private import gtk.Widget;                                              // Widget.
private import gtk.MenuBar;                                             // MenuBar.
private import gtk.Button;                                              // Button.
private import gtk.VBox;                                                // VBox.
private import gtk.HButtonBox;                                          // HButtonBox.
private import gtk.Statusbar;                                           // Statusbar.
private import gtk.Menu;                                                // Menu.
private import gtk.ButtonBox;                                           // ButtonBox.
private import gtk.Dialog;                                              // Dialog.
private import gtk.MessageDialog;                                       // MessageDialog.

class MyWindow : ApplicationWindow {
    public:
    this(Application application) {
        super(application);
        setTitle("DRaw");
        setup();
        showAll();
        string versionCompare = Version.checkVersion(3, 0, 0);
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
        ConnectDialog connectDialog = new ConnectDialog();
    }

    protected void disconnectWhiteboard(Button button) {
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
}
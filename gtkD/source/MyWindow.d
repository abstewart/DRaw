// Imports.
private import std.stdio;                                               // writeln.
private import stdlib = core.stdc.stdlib : exit;

private import DisconnectDialog : DisconnectDialog;
private import ConnectDialog : ConnectDialog;
private import AppBox : AppBox;
private import DRawAbout : DRawAbout;

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

/// Class representing the main window of the application.
class MyWindow : ApplicationWindow {
    /// Constructor.
    public:
    this(Application application) {
        super(application);
        setTitle("DRaw");                       // Sets the title of the gtk.Window The title of a window will be displayed in its title bar.
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

    /// Deconstructor.
    ~this(){
        writeln("MyWindow destructor");
    }

    // Method used to set up the window.
    private void setup() {
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

    // Method that creates a new ConnectDialog.
    private void connectWhiteboard(Button button) {
        ConnectDialog connectDialog = new ConnectDialog();
    }

    // Method that creates a new DisconnectDialog.
    private void disconnectWhiteboard(Button button) {
        DisconnectDialog disconnectDialog = new DisconnectDialog();
    }

    // What happens when the user exits the window.
    private void anyButtonExits(Button button) {
        writeln("Exit program");
        // TODO: Disconnect from server, if connected.
        stdlib.exit(0);
    }

    // What happens when the user clicks the About item in the Help menu.
    private void onMenuActivate(MenuItem menuItem) {
        string action = menuItem.getActionName();
        switch (action) {
            case "help.about":
            DRawAbout dlg = new DRawAbout();
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

    // Helper method to get the menu bar for the window.
    private MenuBar getMenuBar() {
        AccelGroup accelGroup = new AccelGroup();
        addAccelGroup(accelGroup);
        MenuBar menuBar = new MenuBar();
        Menu menu = menuBar.append("_Help");
        menu.append(new MenuItem(&onMenuActivate, "_About","help.about", true, accelGroup, 'a',
        GdkModifierType.CONTROL_MASK|GdkModifierType.SHIFT_MASK));
        return menuBar;
    }
}
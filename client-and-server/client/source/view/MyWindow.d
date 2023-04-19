module view.MyWindow;

private import stdlib = core.stdc.stdlib : exit;
private import std.algorithm.comparison : equal;
private import glib.Timeout;
private import gtk.CssProvider;
private import gtk.StyleContext;
private import gdk.Screen;
private import gio.FileIF;
private import gdk.c.types;
private import gtk.Version;
private import gtk.Application;
private import gtk.ApplicationWindow;
private import gtk.AccelGroup;
private import gtk.MenuItem;
private import gtk.Widget;
private import gtk.MenuBar;
private import gtk.Button;
private import gtk.VBox;
private import gtk.HBox;
private import gtk.HButtonBox;
private import gtk.Statusbar;
private import gtk.Menu;
private import gtk.ButtonBox;
private import gtk.Dialog;
private import gtk.MessageDialog;

private import view.components.DisconnectDialog;
private import view.components.ConnectDialog;
private import view.AppBox;
private import view.components.DRawAbout;
private import view.components.ChatBox;
private import view.components.MyChatBox;
private import model.Communicator;
private import model.packets.packet;

/**
 * Class representing the main window of the application. 
 */
class MyWindow : ApplicationWindow
{
private:
    bool isConnected;
    ChatBox chatBox;
    AppBox appBox;
    Timeout timeout;
    string username;

public:
    /**
    * Constructs a MyWindow instance.
    *
    * Params:
    *        application : Application : an application instance
    */
    this(Application application)
    {
        super(application);

        // Injects CSS in OSX and Linux, doesn't inject in Windows.
        version (OSX)
        {
            CssProvider provider = new CssProvider();
            auto css = import("gtk.css");
            provider.loadFromData(css);
            Screen def = Screen.getDefault();
            StyleContext.addProviderForScreen(def, provider, GTK_STYLE_PROVIDER_PRIORITY_USER);
        }
        version (linux)
        {
            CssProvider provider = new CssProvider();
            auto css = import("gtk.css");
            provider.loadFromData(css);
            Screen def = Screen.getDefault();
            StyleContext.addProviderForScreen(def, provider, GTK_STYLE_PROVIDER_PRIORITY_USER);
        }

        setTitle("DRaw"); // Sets the title of the gtk.Window The title of a window will be displayed in its title bar.
        setup();
        addOnDestroy(&quitApp);
        showAll();
        string versionCompare = Version.checkVersion(3, 0, 0);
        if (versionCompare.length > 0)
        {
            MessageDialog d = new MessageDialog(this, GtkDialogFlags.MODAL,
                    MessageType.WARNING, ButtonsType.OK,
                    "GtkD : Gtk+ version missmatch\n" ~ versionCompare
                    ~ "\nYou might run into problems!" ~ "\n\nPress OK to continue");
            d.run();
            d.destroy();
        }
        this.timeout = new Timeout(10, () { return resolveRemotePackets(this); }, false);
        this.isConnected = false;
    }

    /**
    * Gets the client's username.
    *
    * Params:
    *       - username : string : the username to connect with
    */
    public void setUsername(string username)
    {
        this.username = username;
    }

    /**
    * Gets the client's username.
    *
    * Returns:
    *        - username : string : the username to connect with
    */
    public string getUsername()
    {
        return this.username;
    }

    /** 
     * Gets the isConnected variable value.
     * 
     * Returns:
     *        - isConnected : bool : status of server connection
     */
    public bool getConnection()
    {
        return this.isConnected;
    }

    /** 
     * Sets the isConnected variable value.
     *
     * Params:
     *       - value : bool : connection value to set
     */
    public void setConnection(bool value)
    {
        this.isConnected = value;
    }

    /** 
     * Sets up the window structure.
     */
    private void setup()
    {
        setTitle("DRaw"); // Sets the title of the gtk.Window The title of a window will be displayed in its title bar.

        version (Windows)
        {
            setIconFromFile("images/icon.png");
        }

        version (linux)
        {
            setIconFromFile("images/icon.png");
        }

        setBorderWidth(20); // Sets the border width of the container.

        // Sets a position constraint for this window.
        // CENTER_ALWAYS = Keep window centered as it changes size, etc.
        setPosition(GtkWindowPosition.CENTER_ALWAYS);

        // Do not allow users to resize the application.
        setResizable(false);

        // VBox is a container that organizes child widgets into a single column.
        VBox mainBox = new VBox(false, 0);
        mainBox.packStart(getMenuBar(), false, false, 0);

        // AppBox.
        this.appBox = new AppBox();
        mainBox.packStart(this.appBox, false, false, 0);

        // Buttons.
        Button connectButton = new Button(StockID.CONNECT, &connectWhiteboard, true);
        connectButton.setTooltipText("Connect");
        Button disconnectButton = new Button(StockID.DISCONNECT, &disconnectWhiteboard, true);
        disconnectButton.setTooltipText("Disconnect");
        ButtonBox bBox = HButtonBox.createActionBox();
        bBox.packEnd(connectButton, 0, 0, 10);
        bBox.packEnd(disconnectButton, 0, 0, 10);
        mainBox.packStart(bBox, false, false, 0);

        // Statusbar.
        Statusbar statusbar = new Statusbar();
        mainBox.packStart(statusbar, false, true, 0);

        // Hbox is a container that organizes child widgets into a single row.
        // Create an HBox so that the chat window is the right of the whiteboard.
        HBox hbox = new HBox(false, 4);
        hbox.packStart(mainBox, false, false, 2);

        // ChatBox.
        this.chatBox = new ChatBox(this, ""); // Initially the username is set to an empty string.
        hbox.packStart(this.chatBox, false, false, 0);

        // Add hbox to Window.
        add(hbox);
    }

    /**
     * Gets the appBox inside of MyWindow. Used in CommandBuilder.d.
     *
     * Returns: 
     *        - appbox : AppBox : the application box
     */
    public AppBox getAppBox()
    {
        return this.appBox;
    }

    /**
     * Gets the chatBox inside of MyWindow.
     *
     * Returns:
     *       - chatBox : ChatBox : the chat box
     */
    public ChatBox getChatBox()
    {
        return this.chatBox;
    }

    /**
     * Creates a new connection dialogue.
     *
     * Params: 
     *       - button : Button : button to click to create new dialogue.
     */
    private void connectWhiteboard(Button button)
    {
        ConnectDialog connectDialog = new ConnectDialog(this);
        if (this.isConnected)
        {
            MyChatBox myChatBox = this.chatBox.getMyChatBox();
            myChatBox.setUsername(connectDialog.getUsername());
        }
    }

    /**
     * Creates a new disconnection dialogue.
     *
     * Params: 
     *       - button : Button : button to click to create new dialogue
     */
    private void disconnectWhiteboard(Button button)
    {
        DisconnectDialog disconnectDialog = new DisconnectDialog(this);
    }

    /**
     * Activates the about menu window on item click.
     *
     * Params:
     *       - menuItem : MenuItem : menu item to click
     */
    private void onMenuActivate(MenuItem menuItem)
    {
        string action = menuItem.getActionName();
        switch (action)
        {
        case "help.about":
            DRawAbout dlg = new DRawAbout();
            dlg.showAll();
            dlg.run();
            dlg.destroy();
            break;
        default:
            MessageDialog d = new MessageDialog(this, GtkDialogFlags.MODAL,
                    MessageType.INFO, ButtonsType.OK, "You pressed menu item " ~ action);
            d.run();
            d.destroy();
            break;
        }
    }

    /**
     * Gets the menu bar for the window.
     *
     * Returns:
     *        - menubar : MenuBar : the menu bar widget
     */
    private MenuBar getMenuBar()
    {
        AccelGroup accelGroup = new AccelGroup();
        addAccelGroup(accelGroup);
        MenuBar menuBar = new MenuBar();
        Menu menu = menuBar.append("_Help");
        menu.append(new MenuItem(&onMenuActivate, "_About", "help.about", true,
                accelGroup, 'a', GdkModifierType.CONTROL_MASK | GdkModifierType.SHIFT_MASK));
        return menuBar;
    }

    /**
     * Quits the application.
     *
     * Params: 
     *       - widget : Widget : the widget to interact with to quit
     */
    public void quitApp(Widget widget)
    {
        // Disconnect from server, if connected.
        Communicator.sendDisconnectPacket(this.username);
        Communicator.disconnect();
        stdlib.exit(0);
    }
}

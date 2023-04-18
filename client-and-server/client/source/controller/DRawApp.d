module controller.DRawApp;

private import gtk.Application;
private import gio.Application : GioApplication = Application;

private import view.MyWindow;

/**
 * Class representing the main DRaw application.
 */
class DRawApp
{
    string[] args;

public:
    /**
     * Constructs a DRawApp instance.
     */
    this(string[] args)
    {
        this.args = args;
    }

    /**
     * Runs the main application
     *
     * Returns:
     *        - status : int : return code of application
     */
    public int runMainApplication()
    {
        auto application = new Application("dRaw.project", GApplicationFlags.FLAGS_NONE);
        application.addOnActivate(delegate void(GioApplication app) {
            new MyWindow(application);
        });
        return application.run(this.args);
    }
}

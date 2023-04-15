module controller.DRawApp;

private import gtkd.Loader;
private import gio.Application : GioApplication = Application;
private import gtk.Application; 

private import view.MyWindow;

/// Class representing the main DRaw application.
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
     */
    public int runMainApplication()
    {
        Linker.dumpLoadLibraries();
        Linker.dumpFailedLoads();
        auto application = new Application("dRaw.project", GApplicationFlags.FLAGS_NONE);
        application.addOnActivate(delegate void(GioApplication app) {
            new MyWindow(application);
        });
        return application.run(this.args);
    }
}

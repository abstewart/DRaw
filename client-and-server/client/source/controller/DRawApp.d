module controller.DRawApp;

// Imports.
private import gtkd.Loader;

private import view.MyWindow;

private import gio.Application : GioApplication = Application; // GioApplication.

private import gtk.Application; // Application.

/// Class representing the main DRaw application.
class DRawApp
{
    // Instance variable.
    string[] args;

    /// Constructs a DRawApp instance.
public:
    this(string[] args)
    {
        this.args = args;
    }

    /// Destructor.
    ~this()
    {
    }

    /// Run the application.
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
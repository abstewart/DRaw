module controller.DRawApp;

// Imports.
private import std.stdio; // writeln.

private import gtkd.Loader;

private import view.MyWindow;

private import gio.Application : GioApplication = Application; // GioApplication.

private import gtk.Application; // Application.

/// Class representing the main DRaw application.
class DRawApp
{
    // Instance variable.
    string[] args;

    /// Constructor.
public:
    this(string[] args)
    {
        writeln("DRawApp constructor");
        this.args = args;
    }

    /// Destructor.
    ~this()
    {
        writeln("DRawApp destructor. Ending application--good bye!");

        // ===================================================================================
        // TODO: Disconnect from server, if connected.
        // ===================================================================================A
    }

    /// Run the application.
    public int runMainApplication()
    {
        Linker.dumpLoadLibraries();
        Linker.dumpFailedLoads();
        auto application = new Application("demo.MyWindow", GApplicationFlags.FLAGS_NONE);
        application.addOnActivate(delegate void(GioApplication app) {
            new MyWindow(application);
        });
        return application.run(this.args);
    }
}

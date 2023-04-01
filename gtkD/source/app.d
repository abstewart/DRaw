// Imports.
private import gtkd.Loader;

private import MyWindow : MyWindow;

private import gio.Application : GioApplication = Application;          // GioApplication.

private import gtk.Application;                                         // Application.

int main(string[] args){
    Linker.dumpLoadLibraries();
    Linker.dumpFailedLoads();
    auto application = new Application("demo.MyWindow", GApplicationFlags.FLAGS_NONE);
    application.addOnActivate(delegate void(GioApplication app) {
        new MyWindow(application);
    });
    return application.run(args);
}
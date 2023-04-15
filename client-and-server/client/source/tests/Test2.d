// ./source/tests/Test2.d
module tests.Test2;

// Imports.
//private import std.algorithm;

private import gtkd.Loader;

private import view.MyWindow;
//private import view.AppBox;
//private import view.components.MyDrawing;
//private import view.components.MyDrawingBox; // MyDrawingBox.
//
private import gio.Application : GioApplication = Application; // GioApplication.
//
//private import gdk.RGBA; // RGBA.
//
private import gtk.Application; // Application.

@("Test 2 -- Testing")
unittest {
    //assert(1 == 1);

    Linker.dumpLoadLibraries();
    Linker.dumpFailedLoads();
    auto application = new Application("dRaw.project", GApplicationFlags.FLAGS_NONE);
    MyWindow myWindow;
    assert(!application.getIsRegistered());
    application.register(null);
    assert(application.getIsRegistered());
    application.addOnActivate(delegate void(GioApplication app) {
        myWindow = new MyWindow(application);
    });
    application.activate();
    assert(!myWindow.getConnection);
    myWindow.setConnection(true);
    assert(myWindow.getConnection);


    //AppBox appBox = myWindow.getAppBox();
    //MyDrawingBox myDrawingBox = appBox.getMyDrawingBox();
//    MyDrawing myDrawing = myDrawingBox.getMyDrawing();
//    RGBA color = new RGBA(cast(double) 0.5, cast(double) 0.5, cast(double) 0.5, 1.0);
//    myDrawing.updateBrushColor(color);
//    assert(myDrawing.getBrushColor().equal(color));
}

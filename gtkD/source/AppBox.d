// Imports.
private import std.stdio;                                               // writeln.

private import MyDrawingArea : MyDrawingArea;                           // MyDrawingArea.

private import gtk.Box;                                                 // Box.

class AppBox : Box {
    private:
    MyDrawingArea myDrawingArea;

    public:
    this() {
        super(Orientation.VERTICAL, 10);
        this.myDrawingArea = new MyDrawingArea();
        packStart(this.myDrawingArea, true, true, 0);
    }

    ~this(){
        writeln("AppBox destructor");
    }
}
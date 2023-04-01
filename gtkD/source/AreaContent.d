// Imports.
private import std.stdio;                                               // writeln.

private import ConnectGrid : ConnectGrid;

private import gtk.Box;                                                 // Box.

class AreaContent {
    private:
    Box _contentArea;
    ConnectGrid _connectGrid;

    public:
    this(Box contentArea) {
        this._contentArea = contentArea;
        this._connectGrid = new ConnectGrid();
        this._contentArea.add(this._connectGrid);
        this._contentArea.showAll();
    }

    ~this(){
        writeln("AreaContent destructor");
    }

    public ConnectGrid getConnectGrid() {
        return this._connectGrid;
    }
}
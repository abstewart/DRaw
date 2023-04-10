module view.components.AreaContent;

// Imports.
private import std.stdio; // writeln.

private import view.components.ConnectGrid;

private import gtk.Box; // Box.

/// Class used in the ConnectDialog.d file.
class AreaContent {
    // Instance variables.
    private:
    Box _contentArea;
    ConnectGrid _connectGrid;

    /// Constructor.
    public:
    this(Box contentArea) {
        writeln("AreaContent constructor");
        this._contentArea = contentArea;
        this._connectGrid = new ConnectGrid();
        this._contentArea.add(this._connectGrid);
        this._contentArea.showAll();
    }

    /// Destructor.
    ~this(){
        writeln("AreaContent destructor");
    }

    /// Getter method -- gets the ConnectGrid of this AreaContent.
    public ConnectGrid getConnectGrid() {
        return this._connectGrid;
    }
}
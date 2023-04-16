module view.components.AreaContent;

private import gtk.Box;

private import view.components.ConnectGrid;

/**
 * Class used in the ConnectDialog.d file.
 */
class AreaContent
{
private:
    Box _contentArea;
    ConnectGrid _connectGrid;

public:
    /**
    * Constructs an AreaContent instance.
    * Params:
    *        contentArea : Box : the content area of an instance of the Connect Dialog
    */
    this(Box contentArea)
    {
        this._contentArea = contentArea;
        this._connectGrid = new ConnectGrid();
        this._contentArea.add(this._connectGrid);
        this._contentArea.showAll();
    }

    /**
     * Gets the connect grid of the content area.
     *
     * Returns:
     *        - connectGrid : ConnectGrid : the connection grid of this component
     */
    public ConnectGrid getConnectGrid()
    {
        return this._connectGrid;
    }
}

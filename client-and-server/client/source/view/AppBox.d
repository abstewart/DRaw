module view.AppBox;

private import view.components.MyDrawingBox;

private import gtk.Box;

/**
 * AppBox used to arrange myDrawingBox using the notion of packing.
 */
class AppBox : Box
{
private:
    MyDrawingBox myDrawingBox;

public:
    /**
     * Constructs an AppBox instance.
     */
    this()
    {
        super(Orientation.VERTICAL, 10);
        this.myDrawingBox = new MyDrawingBox();
        packStart(this.myDrawingBox, true, true, 0); // Adds child to box, packed with reference to the start of box. The child is packed after any other child packed with reference to the start of box.
    }

    /** 
     * Gets myDrawingBox. Only used for unittests.
     */
    public MyDrawingBox getMyDrawingBox()
    {
        return this.myDrawingBox;
    }
}

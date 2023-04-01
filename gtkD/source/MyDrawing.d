// Imports.
private import std.stdio;                               // writeln.
private import std.array;                               // appender.
private import std.math;                                // PI.
private import std.datetime.systime : SysTime, Clock;   // SysTime and Clock.

private import DrawPixelCommand : DrawPixelCommand;
private import ApplicationState : ApplicationState;
private import Command : Command;

private import cairo.Context;                           // Context.
private import cairo.ImageSurface;                      // ImageSurface.

private import gdk.RGBA;                                // RGBA.
private import gdk.Pixbuf;                              // Pixbuf.
private import gdk.Event;                               // Event.

private import gtk.Image;                               // Image.
private import gtk.DrawingArea;                         // DrawingArea.
private import gtk.SpinButton;                          // SpinButton.
private import gtk.Widget;                              // Widget.
private import gtk.ComboBoxText;                        // CombBoxText.
private import gtk.Dialog;                              // Dialog.
private import gtk.Adjustment;                          // Adjustment.

/// Class representing the drawing area that the user is drawing/painting on.
class MyDrawing : DrawingArea {
    // Instance variables.
    private:
    CairoOperator operator = CairoOperator.OVER;
    ImageSurface surface;
    RGBA rgbaColor;
    int width;
    int height;
    bool buttonIsDown;
    string primitiveType;
    Image image;
    Pixbuf scaledPixbuf;
    SpinButton spin;
    GtkAllocation size;                 // The area assigned to the DrawingArea by its parent.
    Pixbuf pixbuf;                      // An 8-bit/pixel image buffer.
    string[] pngOptions;
    string[] pngOptionValues;
    int xOffset = 0;
    int yOffset = 0;
    ApplicationState applicationState = new ApplicationState();

    /// Constructor.
    public:
    this() {
        setSizeRequest(500, 300);            // Width, height.
        this.width = getWidth();
        this.height = getHeight();
        this.primitiveType = "Filled Arc";
        this.rgbaColor = new RGBA(cast(double)0, cast(double)0, cast(double)0);        // Intially black.
        writeln("The initial brush color is: ", this.rgbaColor.toString);
        this.spin = new SpinButton(new Adjustment(30, 1, 400, 1, 10, 0), 1, 0);
        sizeSpinChanged(this.spin);
        this.spin.addOnValueChanged(&sizeSpinChanged);

        addOnDraw(&onDraw);                         // This signal is emitted when a widget is supposed to render itself.
        addOnMotionNotify(&onMotionNotify);         // This motion notify event signal is emitted when the pointer moves over the widget's gdk.Window.
        addOnSizeAllocate(&onSizeAllocate);
        addOnButtonPress(&onButtonPress);           // This button press event signal will be emitted when a button (typically from a mouse) is pressed.
        addOnButtonRelease(&onButtonRelease);       // This button press event signal will be emitted when a button (typically from a mouse) is released.
    }

    /// Deconstructor.
    ~this(){
        writeln("MyDrawing destructor");
    }

    /// Getter method -- gets the spin button.
    public SpinButton getSpin() {
        return this.spin;
    }

    /// Method called when the user selects a color in the color chooser dialog.
    public void updateBrushColor(RGBA newColor) {
        this.rgbaColor = newColor;
        writeln("The new brush color is: ", this.rgbaColor.toString);
    }

    /// Method called when the user clicks the Save button.
    public void saveWhiteboard() {
        Context context = Context.create(this.surface);
        getAllocation(this.size);                        // Grab the widget's size as allocated by its parent.
        this.pixbuf = getFromSurface(context.getTarget(), this.xOffset, this.yOffset,
        this.size.width, this.size.height); // The contents of the surface go into the buffer.

        // Prepare and write PNG file.
        this.pngOptions = ["x-dpi", "y-dpi", "compression"];
        this.pngOptionValues = ["150", "150", "1"];

        // Create the file path.
        auto filePath = appender!string();
        filePath.put('.');
        filePath.put('/');
        SysTime currentTime = Clock.currTime();
        foreach (char c ; currentTime.toString()) {
            filePath.put(c);
        }
        filePath.put('.');
        filePath.put('p');
        filePath.put('n');
        filePath.put('g');

        if (pixbuf.savev(filePath[], "png", pngOptions, pngOptionValues)) {
            writeln(filePath[], " was successfully saved.");
        }
    }

    /// Method called when the user clicks the Undo button.
    public void undoWhiteboard() {
        writeln("Undoing: History length = ", this.applicationState.getHistory().length);
        // Retrieve the most recent command.
        Command cmd = this.applicationState.popHistory();

        // Call the undo function.
        if (cmd !is null) {
            cmd.undo();
        }
    }

    // Set width, height, and surface.
    private void onSizeAllocate(GtkAllocation* allocation, Widget widget) {
        this.width = allocation.width;
        this.height = allocation.height;
        this.surface = ImageSurface.create(CairoFormat.ARGB32, this.width, this.height);
    }

    // When the mouse is held down this.buttonIsDown = true and execute (draw/paint).
    private bool onButtonPress(Event event, Widget widget) {
        if (event.type == EventType.BUTTON_PRESS && event.button.button == 1) {
            this.buttonIsDown = true;
            int x = cast(int)event.button.x;
            int y = cast(int)event.button.y;
            // Draw/paint.
            DrawPixelCommand newDrawPixelCommand = new DrawPixelCommand(x, y, Context.create(this.surface), this.rgbaColor,
            this.spin.getValueAsInt(), this.primitiveType);
            newDrawPixelCommand.execute();
            // Redraw the Widget. Must be called after execute.
            queueDraw();

            // Add the command to the history.
            this.applicationState.addToHistory(newDrawPixelCommand);
        }
        return false;
    }

    // When the mouse is held down this.buttonIsDown = false.
    private bool onButtonRelease(Event event, Widget widget) {
        if (event.type == EventType.BUTTON_RELEASE && event.button.button == 1) {
            this.buttonIsDown = false;
        }
        return false;
    }

    // This will be called from the expose event call back.
    private bool onDraw(Scoped!Context context, Widget widget) {
        // Fill the Widget with the surface we are drawing on.
        context.setSourceSurface(this.surface, 0, 0);
        context.paint();
        return true;
    }

    // This detects motion on the whiteboard. If the mouse is still in motion and the
    // mouse is being held down execute (draw/paint).
    private bool onMotionNotify(Event event, Widget widget) {
        if (this.buttonIsDown && event.type == EventType.MOTION_NOTIFY) {
            int x = cast(int)event.button.x;
            int y = cast(int)event.button.y;
            // Draw/paint.
            DrawPixelCommand newDrawPixelCommand = new DrawPixelCommand(x, y, Context.create(this.surface), this.rgbaColor,
            this.spin.getValueAsInt(), this.primitiveType);
            newDrawPixelCommand.execute();
            // Redraw the Widget. Must be called after execute.
            queueDraw();

            // Add the command to the history.
            this.applicationState.addToHistory(newDrawPixelCommand);
        }
        return true;
    }

    // What is called when the brush/pen size is changed. It will be called when the app initially opens
    // and when the user updates the brush/pen size.
    private void sizeSpinChanged(SpinButton spinButton) {
        if (!(this.scaledPixbuf is null)) {
            int width = spinButton.getValueAsInt();
            this.scaledPixbuf = image.getPixbuf();
            float ww = width * this.scaledPixbuf.getWidth() / 30;
            float hh = width * this.scaledPixbuf.getHeight() / 30;
            this.scaledPixbuf = scaledPixbuf.scaleSimple(cast(int)ww, cast(int)hh, GdkInterpType.HYPER);
        }
    }

    /// Method used in MyDrawingArea.d file. Used to set the primitive type.
    public void onPrimOptionChanged(ComboBoxText comboBoxText) {
        this.primitiveType = comboBoxText.getActiveText();
    }
}
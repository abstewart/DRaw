// Imports.
private import std.stdio;                                               // writeln.
private import std.array;                               // appender.
private import std.math;                                // PI.
private import std.datetime.systime : SysTime, Clock;           // SysTime and Clock.

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

class MyDrawing : DrawingArea, Command {
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

        addOnDraw(&onDraw);
        addOnMotionNotify(&onMotionNotify);
        addOnSizeAllocate(&onSizeAllocate);
        addOnButtonPress(&onButtonPress);
        addOnButtonRelease(&onButtonRelease);
    }

    ~this(){
        writeln("MyDrawing destructor");
    }

    public SpinButton getSpin() {
        return this.spin;
    }

    public void updateBrushColor(RGBA newColor) {
        writeln("In updateBrushColor");
        this.rgbaColor = newColor;
        writeln("The new brush color is: ", this.rgbaColor.toString);
    }

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

    public void onSizeAllocate(GtkAllocation* allocation, Widget widget) {
        this.width = allocation.width;
        this.height = allocation.height;
        this.surface = ImageSurface.create(CairoFormat.ARGB32, this.width, this.height);
    }

    // When the mouse is held down this.buttonIsDown = true and execute (draw/paint).
    public bool onButtonPress(Event event, Widget widget) {
        if (event.type == EventType.BUTTON_PRESS && event.button.button == 1) {
            this.buttonIsDown = true;
            // Draw/paint.
            Execute(cast(int)event.button.x, cast(int)event.button.y);
        }
        return false;
    }

    // When the mouse is held down this.buttonIsDown = false.
    public bool onButtonRelease(Event event, Widget widget) {
        if (event.type == EventType.BUTTON_RELEASE && event.button.button == 1) {
            this.buttonIsDown = false;
        }
        return false;
    }

    // This will be called from the expose event call back.
    public bool onDraw(Scoped!Context context, Widget widget) {
        // Fill the Widget with the surface we are drawing on.
        context.setSourceSurface(this.surface, 0, 0);
        context.paint();
        return true;
    }

    // This detects motion on the whiteboard. If the mouse is still in motion and the
    // mouse is being held down execute (draw/paint).
    public bool onMotionNotify(Event event, Widget widget) {
        if (this.buttonIsDown && event.type == EventType.MOTION_NOTIFY) {
            // Draw/paint.
            Execute(cast(int)event.motion.x, cast(int)event.motion.y);
        }
        return true;
    }

    public void sizeSpinChanged(SpinButton spinButton) {
        if (!(this.scaledPixbuf is null)) {
            int width = spinButton.getValueAsInt();
            this.scaledPixbuf = image.getPixbuf();
            float ww = width * this.scaledPixbuf.getWidth() / 30;
            float hh = width * this.scaledPixbuf.getHeight() / 30;
            this.scaledPixbuf = scaledPixbuf.scaleSimple(cast(int)ww, cast(int)hh, GdkInterpType.HYPER);
        }
    }

    public int Execute(int x, int y) {
        int width = this.spin.getValueAsInt();
        int height = width * 3 / 4;
        Context context = Context.create(this.surface);
        context.setOperator(operator);
        const double ALPHAVALUE = 1.0;
        double rValue = this.rgbaColor.red();
        double gValue = this.rgbaColor.green();
        double bValue = this.rgbaColor.blue();
        context.setSourceRgba(rValue, gValue, bValue, ALPHAVALUE);

        debug(trace) {
            writefln("primitiveType = %s", primitiveType);
        }

        switch (primitiveType) {
            case "Arc":
                context.arc(x - width / 2, y - width / 2, width, 0, 2 * PI);
                context.stroke();
                break ;
            case "Filled Arc":
                context.arc(x - width / 4, y - width / 4, width / 2, 0, 2 * PI);
                context.fill();
                break ;
            case "Line":
                context.moveTo(x, y);
                context.lineTo(x+width, y);
                context.stroke();
                break ;
            case "Point":
                context.rectangle(x, y, 1, 1);
                context.fill();
                break ;
            case "Rectangle":
                context.rectangle(x - width / 2, y - width / 4, width, height);
                context.stroke();
                break ;
            case "Filled Rectangle":
                context.rectangle(x - width / 2, y - width / 4, width, height);
                context.fill();
                break ;
            default:
                context.arcNegative(x  -2, y - 2, 4, 0, 6);
                context.fill();
                break ;
        }

        // Redraw the Widget.
        this.queueDraw();
        return 0;
    }

    public int Undo(int x, int y) {
        // TODO
        return 0;
    }

    public void onPrimOptionChanged(ComboBoxText comboBoxText) {
        this.primitiveType = comboBoxText.getActiveText();
    }
}
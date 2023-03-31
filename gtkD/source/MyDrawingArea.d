// Imports.
private import std.stdio;                               // writeln.
private import std.array;                               // appender.
private import std.math;                                // PI.
import std.datetime.systime : SysTime, Clock;           // SysTime and Clock.

private import cairo.Context;                           // Context.
private import cairo.ImageSurface;                      // ImageSurface.

private import gdk.RGBA;                                // RGBA.
private import gdk.Pixbuf;                              // Pixbuf.
private import gdk.Event;                               // Event.

private import gtk.VBox;                                // VBox.
private import gtk.ColorChooserDialog;                  // ColorChooserDialog.
private import gtk.Dialog;                              // Dialog.
private import gtk.Button;                              // Button.
private import gtk.Label;                               // Label.
private import gtk.Widget;                              // Widget.
private import gtk.ComboBox;                            // ComboBox.
private import gtk.ComboBoxText;                        // CombBoxText.
private import gtk.Adjustment;                          // Adjustment.
private import gtk.HBox;                                // HBox.
private import gtk.DrawingArea;                         // DrawingArea.
private import gtk.Image;                               // Image.
private import gtk.SpinButton;                          // SpinButton.

interface Command{
    int Execute(int x, int y);
    int Undo(int x, int y);
}

class MyDrawingArea : VBox {
    MyDrawing drawingArea;
    MyColorChooserDialog d;

    this() {
        super(false, 4);

        this.drawingArea = new MyDrawing();

        ComboBoxText primOption = new ComboBoxText();
        primOption.appendText("Filled Arc");
        primOption.appendText("Arc");
        primOption.appendText("Line");
        primOption.appendText("Point");
        primOption.appendText("Rectangle");
        primOption.appendText("Filled Rectangle");
        primOption.setActive(0);
        primOption.addOnChanged(&this.drawingArea.onPrimOptionChanged);

        packStart(this.drawingArea, true, true,0);

        Button colorButton = new Button("Color Dialog", &showColor);
        Button undoButton = new Button(StockID.UNDO, &undoWhiteboard);
        Button saveButton = new Button(StockID.SAVE, &saveWhiteboard);

        HBox hbox = new HBox(false, 4);
        hbox.packStart(new Label("Brush type"), false, false, 2);
        hbox.packStart(primOption, false, false, 2);
        hbox.packStart(new Label("Brush size"), false, false, 2);
        hbox.packStart(this.drawingArea.spin, false, false, 2);
        hbox.packStart(colorButton, false, false, 2);
        hbox.packStart(undoButton, false, false, 2);
        hbox.packStart(saveButton, false, false, 2);

        packStart(hbox, false, false, 0);
    }

    void showColor(Button button) {
        if (d  is  null) {
            d = new MyColorChooserDialog(this.drawingArea);
        }
        d.run();
        d.hide();
    }

    void saveWhiteboard(Button button) {
        writeln("Save whiteboard to a file");
        this.drawingArea.saveWhiteboard();
    }

    void undoWhiteboard(Button button) {
        writeln("Undo command on whiteboard");
        // TODO
    }

    class MyColorChooserDialog : ColorChooserDialog {
        private:
        string title = "Color Selection";
        DialogFlags flags = GtkDialogFlags.MODAL;
        RGBA selectedColor;
        MyDrawing drawingArea;

        public:
        this(MyDrawing drawingArea) {
            super(title, null);
            addOnResponse(&doSomething);
            this.drawingArea = drawingArea;
        }

        protected:
        void doSomething(int response, Dialog d) {
            getRgba(selectedColor);
            writeln("New color selection: ", selectedColor);
            this.drawingArea.updateBrushColor(selectedColor);
        }
    }

    class MyDrawing : DrawingArea, Command {
        private:
        //              R    G    B    Alpha
        float[] rgba = [0.3, 0.6, 0.2, 0.9];
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
        string[] jpegOptions;
        string[] jpegOptionValues;
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

        public void updateBrushColor(RGBA newColor) {
            writeln("In updateBrushColor");
            this.rgbaColor = newColor;
            writeln("The new brush color is: ", this.rgbaColor.toString);
        }

        // TODO: Make the background of the image white -- not black.
        public void saveWhiteboard() {
            Context context = Context.create(this.surface);
            getAllocation(size);                        // Grab the widget's size as allocated by its parent.
            this.pixbuf = getFromSurface(context.getTarget(), this.xOffset, this.yOffset,
                                    this.size.width, this.size.height); // The contents of the surface go into the buffer.

            // Prepare and write JPEG file.
            this.jpegOptions = ["quality"];
            this.jpegOptionValues = ["100"];

            // Create the file path.
            auto filePath = appender!string();
            filePath.put('.');
            filePath.put('/');
            SysTime currentTime = Clock.currTime();
            foreach (char c ; currentTime.toString()) {
                filePath.put(c);
            }
            filePath.put('.');
            filePath.put('j');
            filePath.put('p');
            filePath.put('e');
            filePath.put('g');

            writeln("file path = ", filePath[]);

            if (this.pixbuf.savev(filePath[], "jpeg", this.jpegOptions, this.jpegOptionValues)) {
                writeln("JPEG was successfully saved.");
            }
        }

        void onSizeAllocate(GtkAllocation* allocation, Widget widget) {
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

        /**
		 * This will be called from the expose event call back.
		 * \bug this is called on get or loose focus - review
		 */
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
            if (!(scaledPixbuf is null)) {
                int width = spinButton.getValueAsInt();
                this.scaledPixbuf = image.getPixbuf();

                float ww = width * this.scaledPixbuf.getWidth() / 30;
                float hh = width * this.scaledPixbuf.getHeight() / 30;

                scaledPixbuf = scaledPixbuf.scaleSimple(cast(int)ww, cast(int)hh, GdkInterpType.HYPER);
            }
        }

        int Execute(int x, int y) {
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

        int Undo(int x, int y) {
            // TODO
            return 0;
        }

        void onPrimOptionChanged(ComboBoxText comboBoxText) {
            this.primitiveType = comboBoxText.getActiveText();
        }
    }
}
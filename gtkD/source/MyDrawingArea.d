// Imports.
private import std.stdio;                               // writeln.
private import std.math;                                // PI.

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
    int Execute();
    int Undo();
}

class MyDrawingArea : VBox {
    TestDrawing drawingArea;
    MyColorChooserDialog d;

    this() {
        super(false, 4);

        this.drawingArea = new TestDrawing();

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

        HBox hbox = new HBox(false, 4);
        hbox.packStart(new Label("Brush type"), false, false, 2);
        hbox.packStart(primOption, false, false, 2);
        hbox.packStart(new Label("Brush size"), false, false, 2);
        hbox.packStart(this.drawingArea.spin, false, false, 2);
        hbox.packStart(new Label("Paint color"), false, false, 2);
        hbox.packStart(colorButton, false, false, 2);

        packStart(hbox, false, false, 0);
    }

    class MyColorChooserDialog : ColorChooserDialog {
        private:
        string title = "Color Selection";
        DialogFlags flags = GtkDialogFlags.MODAL;
        RGBA selectedColor;
        TestDrawing drawingArea;

        public:
        this(TestDrawing drawingArea) {
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

    void showColor(Button button) {
        if (d  is  null) {
            d = new MyColorChooserDialog(this.drawingArea);
        }
        d.run();
        d.hide();
    }

    class TestDrawing : DrawingArea, Command {
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

            addOnDraw(&drawCallback);
            addOnMotionNotify(&onMotionNotify);
            addOnSizeAllocate(&onSizeAllocate);
            addOnButtonPress(&onButtonPress);
            addOnButtonRelease(&onButtonRelease);
        }

        ~this(){
            writeln("TestDrawing destructor");
        }

        public void updateBrushColor(RGBA newColor) {
            writeln("In updateBrushColor");
            this.rgbaColor = newColor;
            writeln("The new brush color is: ", this.rgbaColor.toString);
        }

        int Execute() {
            return 0;
        }

        int Undo() {
            return 0;
        }

        void onSizeAllocate(GtkAllocation* allocation, Widget widget) {
            width = allocation.width;
            height = allocation.height;

            surface = ImageSurface.create(CairoFormat.ARGB32, width, height);
        }

        public bool onButtonPress(Event event, Widget widget) {
            debug(trace) {
                writeln("button DOWN");
            }
            if (event.type == EventType.BUTTON_PRESS && event.button.button == 1) {
                debug(trace) {
                    writeln("Button 1 down");
                }
                buttonIsDown = true;

                drawPrimitive(cast(int)event.button.x, cast(int)event.button.y);
            }
            return false;
        }

        public bool onButtonRelease(Event event, Widget widget) {
            debug(trace) {
                writeln("button UP");
            }
            if (event.type == EventType.BUTTON_RELEASE && event.button.button == 1) {
                debug(trace) {
                    writeln("Button 1 UP");
                }
                buttonIsDown = false;
            }
            return false;
        }

        /**
		 * This will be called from the expose event call back.
		 * \bug this is called on get or loose focus - review
		 */
        public bool drawCallback(Scoped!Context context, Widget widget) {
            // Fill the Widget with the surface we are drawing on.
            context.setSourceSurface(surface, 0, 0);
            context.paint();

            return true;
        }

        public bool onMotionNotify(Event event, Widget widget) {
            if (buttonIsDown && event.type == EventType.MOTION_NOTIFY) {
                drawPrimitive(cast(int)event.motion.x, cast(int)event.motion.y);
            }
            return true;
        }

        public void sizeSpinChanged(SpinButton spinButton) {
            if (!(scaledPixbuf is null)) {
                int width = spinButton.getValueAsInt();
                scaledPixbuf = image.getPixbuf();

                float ww = width * scaledPixbuf.getWidth() / 30;
                float hh = width * scaledPixbuf.getHeight() / 30;

                scaledPixbuf = scaledPixbuf.scaleSimple(cast(int)ww, cast(int)hh, GdkInterpType.HYPER);
            }
        }

        public void drawPrimitive(int x, int y) {
            int width = this.spin.getValueAsInt();
            int height = width * 3 / 4;

            Context context = Context.create(surface);
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
        }

        void onPrimOptionChanged(ComboBoxText comboBoxText) {
            primitiveType = comboBoxText.getActiveText();
        }
    }
}
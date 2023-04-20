module view.components.MyDrawing;

private import std.array;
private import std.math;
private import std.datetime.systime : SysTime, Clock;
private import std.typecons;
private import std.algorithm;
private import gdk.RGBA;
private import gdk.Pixbuf;
private import gdk.Event;
private import gtk.Image;
private import gtk.DrawingArea;
private import gtk.SpinButton;
private import gtk.Widget;
private import gtk.ComboBoxText;
private import gtk.Dialog;
private import gtk.Adjustment;
private import cairo.Context;
private import cairo.ImageSurface;

private import model.ApplicationState;
private import model.Communicator;
private import model.packets.packet;
private import controller.commands.Command;
private import controller.commands.DrawArcCommand;
private import controller.commands.DrawFilledArcCommand;
private import controller.commands.DrawFilledRectangleCommand;
private import controller.commands.DrawLineCommand;
private import controller.commands.DrawPointCommand;
private import controller.commands.DrawRectangleCommand;

/**
 * Class representing the drawing area that the user is drawing/painting on.
 */
class MyDrawing : DrawingArea
{
private:
    CairoOperator operator = CairoOperator.OVER;
    ImageSurface surface;
    RGBA currentColor;
    int width;
    int height;
    bool buttonIsDown;
    string brushType;
    Image image;
    Pixbuf scaledPixbuf;
    SpinButton spin;
    GtkAllocation size; // The area assigned to the DrawingArea by its parent.
    Pixbuf pixbuf; // An 8-bit/pixel image buffer.
    string[] pngOptions;
    string[] pngOptionValues;
    int xOffset = 0;
    int yOffset = 0;
    ApplicationState applicationState = new ApplicationState();

public:
    /**
     * Constructs a myDrawing instance.
     */
    this()
    {
        // Set the size of the whiteboard.
        setSizeRequest(900, 500); // Width, height.
        this.width = getWidth();
        this.height = getHeight();
        this.brushType = "Filled Arc";

        this.currentColor = new RGBA(cast(double) 1, cast(double) 1, cast(double) 1, 1.0); // Intially opaque black.

        this.spin = new SpinButton(new Adjustment(15, 1, 400, 1, 10, 0), 1, 0); // 15 is the initial brush size.
        sizeSpinChanged(this.spin);
        this.spin.addOnValueChanged(&sizeSpinChanged);

        addOnDraw(&onDraw); // This signal is emitted when a widget is supposed to render itself.
        addOnMotionNotify(&onMotionNotify); // This motion notify event signal is emitted when the pointer moves over the widget's gdk.Window.
        addOnSizeAllocate(&onSizeAllocate);
        addOnButtonPress(&onButtonPress); // This button press event signal will be emitted when a button (typically from a mouse) is pressed.
        addOnButtonRelease(&onButtonRelease); // This button press event signal will be emitted when a button (typically from a mouse) is released.
    }
    /**
     * Gets the spin button.
     *
     * Returns:
     *        - button : SpinButton : the spin button
     */
    public SpinButton getSpin()
    {
        return this.spin;
    }

    /** 
     * Gets the image surface.
     *
     * Returns:
     *        - surface : ImageSurface : the image surface of the drawing
     */
    public ImageSurface getImageSurface()
    {
        return this.surface;
    }

    /**
     * Method called when the user selects a color in the color chooser dialog.
     * 
     * Params:
     *       - newColor : RGBA : the color selected within the dialogue
     */
    public void updateBrushColor(RGBA newColor)
    {
        this.currentColor = newColor;
    }

    /** 
     * Saves the images as a png to disk.
     */
    public void saveWhiteboard()
    {
        Context context = Context.create(this.surface);
        getAllocation(this.size); // Grab the widget's size as allocated by its parent.
        // Transfer image data from a cairo_surface and convert it to an RGB(A) representation inside a gdk.Pixbuf.
        this.pixbuf = getFromSurface(context.getTarget(), this.xOffset,
                this.yOffset, this.size.width, this.size.height); // The contents of the surface go into the buffer.

        // Prepare and write PNG file.
        this.pngOptions = ["x-dpi", "y-dpi", "compression"];
        this.pngOptionValues = ["150", "150", "1"];

        // Create the file path.
        auto filePath = appender!string();
        filePath.put('.');
        filePath.put('/');
        SysTime currentTime = Clock.currTime();
        foreach (char c; currentTime.toString())
        {
            filePath.put(c);
        }
        filePath.put('.');
        filePath.put('p');
        filePath.put('n');
        filePath.put('g');
        this.pixbuf.savev(filePath[], "png", pngOptions, pngOptionValues);
    }

    /**
     * Undo all commands in the command history with the id of the most recent command.
     */
    public void undoWhiteboard()
    {
        // Retrieve the most recent command and remove it from the history array.
        Tuple!(string, int, Command) unameIdCmd = ApplicationState.popFromCommandHistory();
        string usernameToUndo = unameIdCmd[0];
        int idToUndo = unameIdCmd[1];
        if (unameIdCmd[2]!is null)
        {
            int cmdIdToUndo = unameIdCmd[2].getCmdId();
            string packetToSend = encodeUndoCommandPacket(usernameToUndo, idToUndo, cmdIdToUndo);
            Communicator.queueMessageSend(packetToSend);
            unameIdCmd[2].undo();
            Tuple!(string, int, Command)[] validCmds = [];
            foreach (Tuple!(string, int, Command) uIdCmd; ApplicationState.getCommandHistory())
            {
                string user = uIdCmd[0];
                int id = uIdCmd[1];
                Command cmd = uIdCmd[2];
                int cid = cmd.getCmdId();
                if (usernameToUndo.equal(user) && idToUndo == id && cmdIdToUndo == cid)
                {
                    cmd.undo();
                    continue;
                }
                validCmds ~= uIdCmd;
            }
            ApplicationState.setCommandHistory(validCmds);
        }
    }

    /**
     * Sets the width and the height of the surface.
     *
     * Params:
     *       - allocation : GtkAllocation* : pointer to the allocated GTK object
     *       - widget     : Widget : widget object to size allocate
     */
    private void onSizeAllocate(GtkAllocation* allocation, Widget widget)
    {
        this.width = allocation.width;
        this.height = allocation.height;
        this.surface = ImageSurface.create(CairoFormat.ARGB32, this.width, this.height);
        // Fill the surface with an initial color.
        auto ctx = Context.create(this.surface);
        ctx.setSourceRgba(0, 0, 0, currentColor.alpha);
        ctx.paint();
    }

    /**
     * Executes control flow when the button is pressed down.
     *
     * Params:
     *       - event  : Event : the button press event
     *       - widget : Widget : the widget to update
     *
     * Returns:
     *        - false
     */
    private bool onButtonPress(Event event, Widget widget)
    {
        if (event.type == EventType.BUTTON_PRESS && event.button.button == 1)
        {
            this.buttonIsDown = true;
            int x = cast(int) event.button.x;
            int y = cast(int) event.button.y;
            if (0 <= x && x <= this.width && 0 <= y && y <= this.height)
            {
                // Draw/paint. Get the command based on the current brush type and then execute it.
                int id = ApplicationState.getClientId();
                Command newCommand = getCommand(x, y, ApplicationState.getCurCommandId());
                // Add the command to the history.
                Tuple!(string, int, Command) commandPackage = tuple(ApplicationState.getUsername(),
                        id, newCommand);
                ApplicationState.addToCommandHistory(commandPackage);
                // Send the command to the server.
                string packetToSend = encodeUserDrawCommand(ApplicationState.getUsername(),
                        ApplicationState.getClientId(), newCommand);
                Communicator.queueMessageSend(packetToSend);
            }
        }
        return false;
    }

    /**
     * Executes control flow when the button is pressed released.
     *
     * Params:
     *       - event  : Event : the button press event
     *       - widget : Widget : the widget to update
     *
     * Returns:
     *        - false
     */
    private bool onButtonRelease(Event event, Widget widget)
    {
        if (event.type == EventType.BUTTON_RELEASE && event.button.button == 1)
        {
            this.buttonIsDown = false;
            ApplicationState.goToNextCommandId();
        }
        return false;
    }

    /**
     * Updates the surface with whatever has been painted.
     *
     * Params:
     *       - context : Scoped!Context : the context to update
     *       - widget  : Widget : the widget to update
     */
    private bool onDraw(Scoped!Context context, Widget widget)
    {
        // Fill the Widget with the surface we are drawing on.
        context.setSourceSurface(this.surface, 0, 0);
        context.paint();
        return true;
    }

    /**
     * Executes control flow when the button is pressed released. 
     *
     * Params:
     *       - event  : Event : the button press event
     *       - widget : Widget : the widget to update
     *
     * Returns:
     *        - true
     */
    private bool onMotionNotify(Event event, Widget widget)
    {
        if (this.buttonIsDown && event.type == EventType.MOTION_NOTIFY)
        {
            int x = cast(int) event.button.x;
            int y = cast(int) event.button.y;
            if (0 <= x && x <= this.width && 0 <= y && y <= this.height)
            {
                // Draw/paint. Get the command based on the current brush type and then execute it.
                int id = ApplicationState.getClientId();
                Command newCommand = getCommand(x, y, ApplicationState.getCurCommandId());
                // Add the command to the history.
                Tuple!(string, int, Command) commandPackage = tuple(ApplicationState.getUsername(),
                        id, newCommand);
                ApplicationState.addToCommandHistory(commandPackage);
                // Send the command to the server.
                string packetToSend = encodeUserDrawCommand(ApplicationState.getUsername(),
                        ApplicationState.getClientId(), newCommand);
                Communicator.queueMessageSend(packetToSend);
            }
        }
        return true;
    }

    /**
     * Changes the brush size upon button interaction.
     *
     * Params:
     *       - spinButton : SpinButton : button to interact with
     */
    private void sizeSpinChanged(SpinButton spinButton)
    {
        if (!(this.scaledPixbuf is null))
        {
            int width = spinButton.getValueAsInt();
            this.scaledPixbuf = image.getPixbuf();
            float ww = width * this.scaledPixbuf.getWidth() / 30;
            float hh = width * this.scaledPixbuf.getHeight() / 30;
            this.scaledPixbuf = scaledPixbuf.scaleSimple(cast(int) ww,
                    cast(int) hh, GdkInterpType.HYPER);
        }
    }

    /**
     * Gets the command to build given the x, y, and id of the current command.
     *
     * Params:
     *       - x  : int : x pos of desired command
     *       - y  : int : y pos of desired command
     *       - id : int : cid of desired command
     * 
     * Returns:
     *       - command : Command : the created command
     */
    private Command getCommand(int x, int y, int id)
    {
        switch (this.brushType)
        {
        case "Arc":
            return new DrawArcCommand(x, y, this.currentColor,
                    this.spin.getValueAsInt(), this, id);
        case "Filled Arc":
            return new DrawFilledArcCommand(x, y, this.currentColor,
                    this.spin.getValueAsInt(), this, id);
        case "Line":
            return new DrawLineCommand(x, y, this.currentColor,
                    this.spin.getValueAsInt(), this, id);
        case "Point":
            return new DrawPointCommand(x, y, this.currentColor,
                    this.spin.getValueAsInt(), this, id);
        case "Rectangle":
            return new DrawRectangleCommand(x, y, this.currentColor,
                    this.spin.getValueAsInt(), this, id);
        case "Filled Rectangle":
            return new DrawFilledRectangleCommand(x, y, this.currentColor,
                    this.spin.getValueAsInt(), this, id);
        default:
            return new DrawFilledArcCommand(x, y, this.currentColor,
                    this.spin.getValueAsInt(), this, id);
        }
    }

    /**
     * Sets the brush type upon combo box interaction.
     * 
     * Params:
     *       - comboBoxText : ComboBoxTest : the combo box to interact with
     */
    public void onBrushOptionChanged(ComboBoxText comboBoxText)
    {
        this.brushType = comboBoxText.getActiveText();
    }

    /**
     * Clear the drawing board.
     */
    public void clearDrawing()
    {
        auto ctx = Context.create(this.surface);
        ctx.setSourceRgba(0, 0, 0, 1);
        ctx.paint();
    }
}

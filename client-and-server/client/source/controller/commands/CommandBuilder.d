module controller.commands.CommandBuilder;

private import std.array : split;
private import std.conv : to;

private import controller.commands.Command;
private import controller.commands.DrawArcCommand;
private import controller.commands.DrawFilledArcCommand;
private import controller.commands.DrawFilledRectangleCommand;
private import controller.commands.DrawLineCommand;
private import controller.commands.DrawPointCommand;
private import controller.commands.DrawRectangleCommand;
private import view.MyWindow;

/**
 * Constructs a command object from a command id, command type, width, x, y, and color.
 * 
 * Params: 
 *        - cId    : int : the id of the command to create
 *        - cType  : int : the type of the command to create
 *        - cWidth : int : the width of the command to create
 *        - x      : int : the x position of the command to create
 *        - y      : int : the y position of the command to create
 *        - color  : string : the color of the command to create
 *        - window : MyWindow : window object to reference drawing area for drawing commands
 */
Command commandMux(int cId, int cType, int cWidth, int x, int y, string color, MyWindow window)
{
    auto col = color.split('|');
    RGBA cmdColor = new RGBA(to!double(col[0]), to!double(col[1]),
            to!double(col[2]), to!double(col[3]));

    switch (cType)
    {
    case DrawArcCommand.cType:
        return new DrawArcCommand(x, y, cmdColor, cWidth,
                window.getAppBox().getMyDrawingBox().getMyDrawing(), cId);
    case DrawFilledArcCommand.cType:
        return new DrawFilledArcCommand(x, y, cmdColor,
                cWidth, window.getAppBox().getMyDrawingBox().getMyDrawing(), cId);
    case DrawFilledRectangleCommand.cType:
        return new DrawFilledRectangleCommand(x, y,
                cmdColor, cWidth, window.getAppBox().getMyDrawingBox().getMyDrawing(), cId);
    case DrawLineCommand.cType:
        return new DrawLineCommand(x, y, cmdColor,
                cWidth, window.getAppBox().getMyDrawingBox().getMyDrawing(), cId);
    case DrawPointCommand.cType:
        return new DrawPointCommand(x, y, cmdColor,
                cWidth, window.getAppBox().getMyDrawingBox().getMyDrawing(), cId);
    case DrawRectangleCommand.cType:
        return new DrawRectangleCommand(x, y, cmdColor,
                cWidth, window.getAppBox().getMyDrawingBox().getMyDrawing(), cId);
    default:
        return new DrawFilledArcCommand(x, y, cmdColor, cWidth,
                window.getAppBox().getMyDrawingBox().getMyDrawing(), cId);
    }
}

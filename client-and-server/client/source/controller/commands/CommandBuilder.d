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

/**
 * Constructs a command object from a command id, command type, width, x, y, and color
 * 
 * Params: 
 *        - cId    : int : the id of the command to create
 *        - cType  : int : the type of the command to create
 *        - cWidth : int : the width of the command to create
 *        - x      : int : the x position of the command to create
 *        - y      : int : the y position of the command to create
 *        - color  : string : the color of the command to create
 */
Command commandMux(int cId, int cType, int cWidth, int x, int y, string color)
{
    auto col = color.split('|');
    RGBA cmdColor = new RGBA(to!int(col[0]), to!int(col[1]), to!int(col[2]), to!int(col[3]));

    switch (cType)
    {
    case DrawArcCommand.cType:
        return new DrawArcCommand(x, y, cmdColor, cWidth, new MyDrawing(), cId);
    case DrawFilledArcCommand.cType:
        return new DrawFilledArcCommand(x, y,
                cmdColor, cWidth, new MyDrawing(), cId);
    case DrawFilledRectangleCommand.cType:
        return new DrawFilledRectangleCommand(x,
                y, cmdColor, cWidth, new MyDrawing(), cId);
    case DrawLineCommand.cType:
        return new DrawLineCommand(x, y, cmdColor,
                cWidth, new MyDrawing(), cId);
    case DrawPointCommand.cType:
        return new DrawPointCommand(x, y, cmdColor,
                cWidth, new MyDrawing(), cId);
    case DrawRectangleCommand.cType:
        return new DrawRectangleCommand(x, y,
                cmdColor, cWidth, new MyDrawing(), cId);
    default:
        return new DrawFilledArcCommand(x, y, cmdColor, cWidth, new MyDrawing(), cId);
    }
}

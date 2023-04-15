module controller.commands.CommandBuilder;

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
    int arcCmdT = DrawArcCommand.getCmdType();
    int farcCmdT = DrawFilledArcCommand.getCmdType();
    int frectCmdT = DrawFilledRectangleCommand.getCmdType();
    int lineCmdT = DrawLineCommand.getCmdType();
    int pointCmdT = DrawPointCommand.getCmdType();
    int rectCmdT = DrawRectangleCommand.getCmdType();

    auto col = color.split('|');
    RGBA cmdColor = new RGBA(to!int(col[0]), to!int(col[1]), to!int(col[2]), to!int(col[3]));

    switch(cType) {
        case arcCmdT:
            return new DrawArcCommand(x, y, cmdColor, cWidth, new MyDrawing(), cid);
        case farcCmdT:
            return new DrawFilledArcCommand(x, y, cmdColor, cWidth, new MyDrawing(), cid);
        case frectCmdT:
            return new DrawFilledRectangleCommand(x, y, cmdColor, cWidth, new MyDrawing(), cid);
        case lineCmdT:
            return new DrawLineCommand(x, y, cmdColor, cWidth, new MyDrawing(), cid);
        case pointCmdT:
            return new DrawPointCommand(x, y, cmdColor, cWidth, new MyDrawing(), cid);
        case rectCmdT:
            return new DrawRectangleCommand(x, y, cmdColor, cWidth, new MyDrawing(), cid);
        default:
            return new DrawFilledArcCommand(x, y, cmdColor, cWidth, new MyDrawing(), cid);
    }
}
/// The Command interface -- used in MyDrawing.d.
interface Command {
    /// Function for updating the pixels (drawing/painting).
    public int execute();

    /// Function for undoing an Execute command.
    public int undo();
}
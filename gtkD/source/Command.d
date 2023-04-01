/// The Command interface -- used in MyDrawing.d.
interface Command {
    /// Function for updating the pixels (drawing/painting).
    public int Execute(int x, int y);

    /// Function for undoing an Execute command.
    public int Undo(int x, int y);
}
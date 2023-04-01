interface Command {
    public int Execute(int x, int y);
    public int Undo(int x, int y);
}
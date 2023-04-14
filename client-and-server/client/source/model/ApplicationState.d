module model.ApplicationState;

// Imports.
private import std.string;

private import controller.commands.Command;

/// Class that represents the state of the application.
class ApplicationState
{
    // Instance variable.
    private:
    Command[] history;

    /// Constructor.
    public:
    this()
    {
    }

    /// Destructor.
    ~this()
    {
    }

    /// Add the given command to the front of the history array.
    public void addToHistory(Command cmd)
    {
        this.history = cmd ~ this.history;
    }

    //todo remove this test
    @("Test default")
    unittest
    {
        assert(1 == 1);
    }

    /// Pop the last command off the front of the history array. If there are no commands in the history, return null.
    public Command popHistory()
    {
        if (this.history.length >= 1)
        {
            auto lastCommand = history[0];
            history = history[1 .. $];
            return lastCommand;
        }
        else
        {
            return null;
        }
    }

    /// Getter method -- gets the history array.
    public Command[] getHistory()
    {
        return this.history;
    }
}

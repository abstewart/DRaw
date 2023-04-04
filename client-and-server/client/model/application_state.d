module application_state;

// Import D standard libraries
import std.stdio;
import std.string;
import command;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;

import canvas_state : CanvasState;

struct ApplicationState
{
    CanvasState* canvasState;
    //store the history of commands
    //will likely later want to refactor this into another class
    Command[] history;

    this(int x, int y)
    {
        // Create a CanvasState...

        canvasState = new CanvasState(x, y);
    }

    ~this()
    {

    }

    //add the given command to the front of the history list
    void addToHistory(Command cmd)
    {
        history = cmd ~ history;
    }

    Command popHistory()
    {
        if (history.length >= 1)
        {
            auto ans = history[0];
            history = history[1 .. $];
            return ans;
        }
        else
        {
            return null;
        }
    }
}

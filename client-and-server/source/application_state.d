module application_state;

// Import D standard libraries
import std.stdio;
import std.string;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;

import canvas_state : CanvasState;

struct ApplicationState{
    CanvasState* canvasState;

    this(int x, int y) {
        // Create a CanvasState...

        canvasState = new CanvasState(x, y);
    }

    ~this(){

    }
}
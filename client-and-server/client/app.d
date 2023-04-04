import std.stdio;
import SDL_App : SDLApp;

/// Main function. Entry point for the program.
void main()
{

    writeln("This is the client! Hello!!!");
    SDLApp myApp = new SDLApp();
    myApp.MainApplicationLoop();
}

import std.stdio;
import std.getopt;
import SDL_App : SDLApp;

/// Main function. Entry point for the program.
void main(string[] args)
{
    bool disable_window = false;
    auto helpInformation = getopt(
    args,
    "disable_window", "Set to true to prevent window pop-up. Defaults to false.", &disable_window);

    if (helpInformation.helpWanted)
    {
        defaultGetoptPrinter("Help info for this program.", helpInformation.options);
    }


    writeln("This is the client! Hello!!!");
    if (!disable_window)
    {
        SDLApp myApp = new SDLApp();
        myApp.MainApplicationLoop();
    }
}

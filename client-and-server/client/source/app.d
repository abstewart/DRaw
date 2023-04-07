// Imports.
private import std.stdio; // writeln.

private import controller.commands.DRawApp;

/// Main method -- run the application. Entry point for the program.
int mainn(string[] args)
{
    writeln("Starting the DRaw client.");
    DRawApp myApp = new DRawApp(args);
    return myApp.runMainApplication();
}

// Imports.
private import std.stdio; // writeln.

private import DRawApp : DRawApp;

/// Main method -- run the application. Entry point for the program.
int main(string[] args)
{
    writeln("Starting the DRaw client.");
    DRawApp myApp = new DRawApp(args);
    return myApp.runMainApplication();
}

// Import.
private import controller.DRawApp;

/// Client app. Main method -- run the application. Entry point for the program.
int main(string[] args)
{
    DRawApp myApp = new DRawApp(args);
    return myApp.runMainApplication();
}

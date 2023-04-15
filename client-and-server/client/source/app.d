private import controller.DRawApp;

/**
 * Client app. Main method -- run the application. Entry point for the program.
 */
int main(string[] args)
{
    DRawApp app = new DRawApp(args);
    return app.runMainApplication();
}

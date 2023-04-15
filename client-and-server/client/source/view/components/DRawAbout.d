module view.components.DRawAbout;

private import gdk.Pixbuf;
private import gdk.c.types; 
private import gtk.AboutDialog;

/**
 * Class representing the DRaw About page.
 */
class DRawAbout : AboutDialog
{
public:
    /**
     * Constructs a DRawAbout instance.
     */
    this()
    {
        string itemLabel = "About";
        string[] people = [
            "Andrew Briasco-Stewart", "Benjamin Mallett", "Elizabeth Williams",
            "Steven Abbott"
        ];
        string[] artists = ["Elizabeth Williams"];
        string[] documenters = people;
        string comments = "Collaborative Paint Whiteboard";
        string license = "License Foundations of Software Engineering Spring 2023";
        string programName = "DRaw";
        string protection = "Copywrite 2023 © DRaw";
        string pixbufFilename = "images/logo.png";
        Pixbuf logoPixbuf = new Pixbuf(pixbufFilename);

        setAuthors(people); // Sets the strings which are displayed in the authors tab of the secondary credits dialog.
        setArtists(artists); // Sets the strings which are displayed in the artists tab of the secondary credits dialog.
        setCopyright(protection); // Sets the copyright string to display in the about dialog. This should be a short string of one or two lines.
        setComments(comments); // Sets the comments string to display in the about dialog. This should be a short string of one or two lines.
        setLicense(license); // Sets the license information to be displayed in the secondary license dialog. If license is NULL, the license button is hidden.
        setProgramName(programName); // Sets the name to display in the about dialog. If this is not set, it defaults to g_get_application_name().
        setLogo(logoPixbuf); // Sets the pixbuf to be displayed as logo in the about dialog. If it is NULL, the default window icon set with Window.setDefaultIcon will be used.

        // Sets a position constraint for this window.
        // CENTER_ALWAYS = Keep window centered as it changes size, etc.
        setPosition(GtkWindowPosition.CENTER_ALWAYS);
    }
}

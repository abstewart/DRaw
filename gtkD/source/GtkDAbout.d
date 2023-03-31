// Imports.
private import std.stdio;                                               // writeln.

private import gdk.Pixbuf;                                              // Pixbuf.

private import gtk.AboutDialog;                                         // AboutDialog.

class GtkDAbout : AboutDialog {
    public:
    this() {
        string itemLabel = "About";
        string sectionName = "Them What Done Stuff";
        string[] people = ["Andrew Briasco-Stewart", "Benjamin Mallett", "Elizabeth Williams", "Steven Abbott"];
        string[] artists = people;
        string[] documenters = people;
        string comments = "This is a gtkD demo -- DRaw.";
        string license = "License Foundations of Software Engineering Spring 2023";
        string programName = "DRaw";
        string protection = "Copywrite 2023 © DRaw";
        string pixbufFilename = "images/logo.png";
        Pixbuf logoPixbuf = new Pixbuf(pixbufFilename);

        setAuthors(people);
        setArtists(artists);
        addCreditSection(sectionName, people);            // Shows when the Credits button is clicked.
        setCopyright(protection);
        setComments(comments);
        setLicense(license);
        setProgramName(programName);
        setLogo(logoPixbuf);
    }

    ~this(){
        writeln("GtkDAbout destructor");
    }
}
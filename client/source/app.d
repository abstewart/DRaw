import std.stdio;

/// Create a Singleton to store global configuration variables
class Singleton{
    private static Singleton instance;
    int parachuteType;
    int landingZone;

    /// Private constructor
    private this(){}

    /// Retrieves an instance of this singleton while ensuring that only one is ever created
    static Singleton GetInstance(){
        if(instance is null){
            instance = new Singleton;
        }

        return instance;
    }

    /// Reset the values in the singleton
    void reset(){
        parachuteType = 0;
        landingZone = 0;
    }
}

/// Main function. Entry point for the program.
void main()
{
    Singleton meep = Singleton.GetInstance();

    writeln("Edit source/app.d to start your project.");
}

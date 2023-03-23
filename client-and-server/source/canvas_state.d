module canvas_state;


// Import D standard libraries
import std.stdio;
import std.string;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;


/// At the module level, when we terminate, we make sure to
/// terminate SDL, which is initialized at the start of the application.
shared static ~this(){
    // Quit the SDL Application
    SDL_Quit();
    writeln("Ending application--good bye!");
}


struct CanvasState{
    //auto base_surface;
    //auto command_history;
    SDL_Surface* cachedImgSurface;

    this(int x, int y) {
        // Create a surface...

        // Load the bitmap surface
        cachedImgSurface = SDL_CreateRGBSurface(0,x,y,32,0,0,0,0);
    }

    ~this(){
        // Free a surface...

        SDL_FreeSurface(cachedImgSurface);
    }

    /// Function for updating the pixels in a surface to a 'blue-ish' color.
    void UpdateSurfacePixel(int xPos, int yPos, ubyte b, ubyte g, ubyte r){
        // When we modify pixels, we need to lock the surface first
        SDL_LockSurface(cachedImgSurface);
        // Make sure to unlock the surface when we are done.
        scope(exit) SDL_UnlockSurface(cachedImgSurface);

        // Retrieve the pixel arraay that we want to modify
        ubyte* pixelArray = cast(ubyte*)cachedImgSurface.pixels;
        // Change the 'blue' component of the pixels
        pixelArray[yPos*cachedImgSurface.pitch + xPos*cachedImgSurface.format.BytesPerPixel+0] = b;
        // Change the 'green' component of the pixels
        pixelArray[yPos*cachedImgSurface.pitch + xPos*cachedImgSurface.format.BytesPerPixel+1] = g;
        // Change the 'red' component of the pixels
        pixelArray[yPos*cachedImgSurface.pitch + xPos*cachedImgSurface.format.BytesPerPixel+2] = r;
    }

    //// Check a pixel color
    //// Some OtherFunction()
    //MyPixel PixelAt(int x, int y) {
    //    ubyte* pixelArray = cast(ubyte*)imgSurface.pixels;
    //    return MyPixel(
    //        pixelArray[y*imgSurface.pitch + x*imgSurface.format.BytesPerPixel+0],
    //        pixelArray[y*imgSurface.pitch + x*imgSurface.format.BytesPerPixel+1],
    //        pixelArray[y*imgSurface.pitch + x*imgSurface.format.BytesPerPixel+2]
    //    );
    //}
}
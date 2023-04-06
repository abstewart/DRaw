module canvas_state;

// Import D standard libraries
import std.stdio;
import std.string;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;

struct CanvasState
{
    //auto base_surface;
    //auto command_history;
    SDL_Surface* cachedImgSurface;

    this(int x, int y)
    {
        // Create a surface...

        // Load the bitmap surface
        cachedImgSurface = SDL_CreateRGBSurface(0, x, y, 32, 0, 0, 0, 0);
    }

    ~this()
    {
        // Free a surface...

        SDL_FreeSurface(cachedImgSurface);
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

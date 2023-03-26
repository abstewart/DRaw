// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;

import constants;
import command : Command;

class DrawPixelCommand : Command {
    SDL_Surface* old_surface;
    int x,y;
    Color color;
    SDL_Rect affectedArea;

    this(int x, int y, Color color) {
        this.x = x;
        this.y = y;
        color = color;
    }

    void apply(ref SDL_Surface inputSurface) {
        //create the surface only over the area of the command
        //old_surface = SDL_CreateRGBSurface(0,x,y,32,0,0,0,0);
        int brushSize=4;
        //square pixel, based on brush size
        old_surface = SDL_CreateRGBSurface(0,brushSize*2,brushSize*2,32,0,0,0,0);
        //make a sdlrect to cover just the space to copy
        affectedArea = SDL_Rect(x-brushSize, y-brushSize, brushSize*2, brushSize*2);
        SDL_BlitSurface(&inputSurface,&affectedArea,old_surface,null);

        // Loop through and update specific pixels
        // NOTE: No bounds checking performed --
        //       think about how you might fix this :)

        for(int w=-brushSize; w < brushSize; w++){
            for(int h=-brushSize; h < brushSize; h++){
                UpdateSurfacePixel(inputSurface,x+w,y+h,color);
            }
        }
    }

    void undo(ref SDL_Surface inputSurface) {
        SDL_BlitSurface(old_surface,null,&inputSurface,&affectedArea);
    }

    int getCommandType() {
        return 0;
    }

    /// Function for updating the pixels in a surface to a 'blue-ish' color.
    void UpdateSurfacePixel(ref SDL_Surface imgSurface, int xPos, int yPos, Color color){
        // When we modify pixels, we need to lock the surface first
        SDL_LockSurface(&imgSurface);
        // Make sure to unlock the surface when we are done.
        scope(exit) SDL_UnlockSurface(&imgSurface);

        // Retrieve the pixel arraay that we want to modify
        ubyte* pixelArray = cast(ubyte*)imgSurface.pixels;
        // Change the 'blue' component of the pixels
        pixelArray[yPos*imgSurface.pitch + xPos*imgSurface.format.BytesPerPixel+0] = color[0];
        // Change the 'green' component of the pixels
        pixelArray[yPos*imgSurface.pitch + xPos*imgSurface.format.BytesPerPixel+1] = color[1];
        // Change the 'red' component of the pixels
        pixelArray[yPos*imgSurface.pitch + xPos*imgSurface.format.BytesPerPixel+2] = color[2];
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
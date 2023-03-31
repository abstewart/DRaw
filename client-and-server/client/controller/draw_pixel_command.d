// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;

import color : Color;
import command : Command;
import encode_decode;

class DrawPixelCommand : Command {
    SDL_Surface* old_surface;
    int x,y;
    Color color;
    SDL_Rect affectedArea;
    static int commandType = 1;
    int brushSize = 4;

    this(int x, int y, Color color) {
        this.x = x;
        this.y = y;
        this.color = color;
    }

    /**
    * Applies this command over the area necessary in a given surface
    *
    * Params: 
    *        inputSurface = the SDL_Surface to apply the command on
    */
    void apply(ref SDL_Surface inputSurface) {
        //create the surface only over the area of the command
        //old_surface = SDL_CreateRGBSurface(0,x,y,32,0,0,0,0);
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

    /**
    * Undos this command on the given inputSurface.
    *
    * Params:
    *        inputSurface = the SDL_Surface to undo the command from
    *
    * NOTE: this does not perform a check if the command has been applied on the given surface, thus this could provide
    *       unexpected behavior if given an arbitrary canvas
    */
    void undo(ref SDL_Surface inputSurface) {
        SDL_BlitSurface(old_surface,null,&inputSurface,&affectedArea);
    }

    /**
    * Updates the given surface's pixel at the given position to the given color
    *
    * Params: 
    *        imgSurface = the image surface to modify
    *        xPos       = the x position of the pixel to modify
    *        yPos       = the y position of the pixel to modify
    *        color      = the color to update the pixel to
    */
    void UpdateSurfacePixel(ref SDL_Surface imgSurface, int xPos, int yPos, Color color){
        // When we modify pixels, we need to lock the surface first
        SDL_LockSurface(&imgSurface);
        // Make sure to unlock the surface when we are done.
        scope(exit) SDL_UnlockSurface(&imgSurface);

        // Retrieve the pixel arraay that we want to modify
        ubyte* pixelArray = cast(ubyte*)imgSurface.pixels;

        // calculate the positions for the pixel components
        int redCompAtPos = yPos*imgSurface.pitch + xPos*imgSurface.format.BytesPerPixel+0;
        int greenCompAtPos = yPos*imgSurface.pitch + xPos*imgSurface.format.BytesPerPixel+1;
        int blueCompAtPos = yPos*imgSurface.pitch + xPos*imgSurface.format.BytesPerPixel+2;

        // update the pixel components to the correct color
        pixelArray[redCompAtPos] = color.getRed();
        pixelArray[greenCompAtPos] = color.getGreen();
        pixelArray[blueCompAtPos] = color.getBlue();
    }

    /**
    * Encodes the information from this command into a character array.
    *
    * Returns: 
    *         a character array consiting of the information used in this command
    */
    char[] encode() {
        import std.stdio;
        return encodeCommand(this.commandType, this.brushSize, this.color, this.x, this.y);
    }

    /**
    * Decodes an encoded DrawPixelCommand into a DrawPixelCommand object.
    * 
    * Params:
    *        message = a character array representing a DrawPixelCommand
    *        size    = the size of the message
    *
    */
    // static DrawPixelCommand decode(char[] message, long size) {
        
    //     // char[] commandTypeFromMessage = [];
    //     // char[] brushSize = [];
    //     // char[] colorFromMessage = [];
    //     // char[] xPos = [];
    //     // char[] yPos = [];
    //     // char[][] fields = [commandType, brushSize, color, xPos, yPos];
    //     // int pos = 0;
    //     // int fieldNum = 0;
    //     // while (message[pos] != '\r') {
    //     //     if (message[pos] == ',') {
    //     //         fieldNum++;
    //     //         pos++;
    //     //     } else {
    //     //         fields[fieldNum] ~= message[pos];
    //     //         pos++;
    //     //     }
    //     // }
    //     // Color color;
    //     // foreach(colorE; Color) {
    //     //     if (colorE == colorFromMessage) {
    //     //         color = colorE;
    //     //     }
    //     // }
    //     return new DrawPixelCommand(1, 1, Color.BLUE);
    // }

    /**
    * Returns the pixel color at a given position in the current surface
    */
    // Color pixelColorAt(int x, int y) {
    //     // grab
    //    ubyte* pixelArray = cast(ubyte*)imgSurface.pixels;
    //    return MyPixel(
    //        pixelArray[y*imgSurface.pitch + x*imgSurface.format.BytesPerPixel+0],
    //        pixelArray[y*imgSurface.pitch + x*imgSurface.format.BytesPerPixel+1],
    //        pixelArray[y*imgSurface.pitch + x*imgSurface.format.BytesPerPixel+2]
    //    );
    // }

}
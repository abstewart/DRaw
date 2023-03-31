
// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;

interface Command {
    void apply(ref SDL_Surface);

    void undo(ref SDL_Surface);

    char[] encode();
}







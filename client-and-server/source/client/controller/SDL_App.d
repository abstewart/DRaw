/// Run with: 'dub'

// Import D standard libraries
import std.stdio;
import std.string;
import std.conv;
import std.parallelism;
import std.concurrency;
import std.datetime;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;

// Load our custom SDL_Surface library
import application_state : ApplicationState;
import command;
import draw_pixel_command : DrawPixelCommand;
import color : Color;
import client_network;
import deque : Deque;
import encode_decode;

auto TIMEOUT_DUR = 50.msecs;

void handleNetworking(Tid parent) {
    Client network = new Client();

    for( bool active = true; active; ) {
        // gives a 500 microsecond window for the main thread to trigger a send
        // writeln("checking for send from parent");
        auto recv = receiveTimeout(TIMEOUT_DUR,
            // (bool noSendRequested) { writeln("explicit no send"); },
            (immutable bool needToSend, string commandToSend) { 
                writeln("received a packet to send");
                if (needToSend) {network.sendToServer(commandToSend);} 
                },
            (OwnerTerminated error) { active = false; }
        );
        // receives data from our server, note our server is non-blocking
        auto cmdAndLen = network.receiveFromServer();
    
        // if we get a command we need to send it to our parent thread
        if (cmdAndLen[1] > 0) {
            writeln("writing data to parent");
            string encodedCmd = to!string(cmdAndLen[0]);
            immutable long recvLen = cmdAndLen[1];
            send(parent, encodedCmd, recvLen);
        }
    }
}

class SDLApp{
    this(){
        // Handle initialization...
        // SDL_Init
        // Socket Initialization

        // Load the SDL libraries from bindbc-sdl
        // on the appropriate operating system
        version(Windows){
            writeln("Searching for SDL on Windows");
            ret = loadSDL("SDL2.dll");
        }
        version(OSX){
            writeln("Searching for SDL on Mac");
            ret = loadSDL();
        }
        version(linux){
            writeln("Searching for SDL on Linux");
            ret = loadSDL();
        }

        // Error if SDL cannot be loaded
        if(ret != sdlSupport){
            writeln("error loading SDL library");

            foreach( info; loader.errors){
                writeln(info.error,':', info.message);
            }
        }
        if(ret == SDLSupport.noLibrary){
            writeln("error no library found");
        }
        if(ret == SDLSupport.badLibrary){
            writeln("Eror badLibrary, missing symbols, perhaps an older or very new version of SDL is causing the problem?");
        }

        // Initialize SDL
        if(SDL_Init(SDL_INIT_EVERYTHING) !=0){
            writeln("SDL_Init: ", fromStringz(SDL_GetError()));
        }

    }

    ~this(){
        // Handle SDL_QUIT

        // Quit the SDL Application
        SDL_Quit();
        writeln("Ending application--good bye!");
    }

    // Member variables like 'const SDLSupport ret'
    // liklely belong here.
    const SDLSupport ret;

    void MainApplicationLoop(){
        // Create an SDL window
        SDL_Window* window= SDL_CreateWindow("D SDL Painting",
        SDL_WINDOWPOS_UNDEFINED,
        SDL_WINDOWPOS_UNDEFINED,
        640,
        480,
        SDL_WINDOW_SHOWN);
        // Load the bitmap surface
        ApplicationState applicationState = ApplicationState(640, 480);

        // Flag for determing if we are running the main application loop
        bool runApplication = true;
        Command[] cStack;
        Tid network_thread = spawn(&handleNetworking, thisTid);
        // Flag for determining if we are 'drawing' (i.e. mouse has been pressed
        //                                                but not yet released)
        bool drawing = false;

        // Main application loop that will run until a quit event has occurred.
        // This is the 'main graphics loop'
        while(runApplication){
            SDL_Event e;
            // Handle events
            // Events are pushed into an 'event queue' internally in SDL, and then
            // handled one at a time within this loop for as many events have
            // been pushed into the internal SDL queue. Thus, we poll until there
            // are '0' events or a NULL event is returned.
            while(SDL_PollEvent(&e) !=0){
                if(e.type == SDL_QUIT){
                    runApplication= false;
                }
                else if(e.type == SDL_MOUSEBUTTONDOWN){
                    drawing=true;
                }else if(e.type == SDL_MOUSEBUTTONUP){
                    drawing=false;
                }else if(e.type == SDL_MOUSEMOTION && drawing){
                    // retrieve the position
                    int xPos = e.button.x;
                    int yPos = e.button.y;
                    Color lineColor = Color(0,0,255);
                    DrawPixelCommand newDrawPixelCommand = new DrawPixelCommand(xPos, yPos, lineColor);
                    string toSend = to!string(newDrawPixelCommand.encode());
                    immutable bool sendStatus = true;
                    send(network_thread, sendStatus, toSend);
                    // clientNetwork.sendToServer(newDrawPixelCommand.encode());
                    // auto executeTask = task!executeCommand(newDrawPixelCommand, applicationState);
                    // this.executionPool.put(executeTask);
                    // synchronized {
                    cStack ~= [newDrawPixelCommand];
                    applicationState.addToHistory(newDrawPixelCommand);
                    // }
                    //add the command to the history // TODO check for success b4 this?
                    // applicationState.addToHistory(newDrawPixelCommand);
                }else if(e.type == SDL_KEYUP && e.key.keysym.scancode == SDL_SCANCODE_Z){
                    writeln("ZZZZZ!!!!!", applicationState.history.length);
                    //retrieve the most recent command
                    Command cmd = applicationState.popHistory();

                    //call the undo function, passing the img Surface
                    if(cmd !is null){
                        cmd.undo(*applicationState.canvasState.cachedImgSurface);
                    }
                }
            }

            for( bool messageReceived = true; messageReceived; ) {
                messageReceived = receiveTimeout(TIMEOUT_DUR,
                    (string commandEnc, immutable long recv) {
                        writeln("received", commandEnc);
                        Command command = decodePacketToCommandString(commandEnc, recv);
                        cStack ~= [command];
                        }
                );
            }

            while(cStack.length > 0) {
                Command command = cStack[0];
                command.apply(*applicationState.canvasState.cachedImgSurface);  
                cStack = cStack[1..$];
            }
            // Blit the surace (i.e. update the window with another surfaces pixels
            //                       by copying those pixels onto the window).
            SDL_BlitSurface(applicationState.canvasState.cachedImgSurface,null,SDL_GetWindowSurface(window),null);
            // // Update the window surface
            SDL_UpdateWindowSurface(window);
            // Delay for 16 milliseconds
            // Otherwise the program refreshes too quickly
            // auto receiveTask = task!handleReception(this.clientNetwork, this.executionPool, this.cStack);
            // this.receptionPool.put(receiveTask);
            
            SDL_Delay(16);

        }

        // Destroy our window
        SDL_DestroyWindow(window);
    }
}

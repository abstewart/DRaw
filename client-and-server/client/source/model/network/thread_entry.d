module model.network.thread_entry;

import std.stdio;
import std.string;
import std.conv;
import std.concurrency;
import std.datetime;

import model.network.client;

auto TIMEOUT_DUR = 1.msecs; // Timeout for checking interthread messages.

/**
 * Runs the main networking loop for the application. 
 * - Checks for messages from main thread.
 * - Sends any queued packets.
 * - Receives any packets from server.
 * - Notifies main thread of received packets.
 * 
 * Params:
 *        - parent : Tid : the thread id of the parent thread
 *        - ipAddr : string : the ip address to connect to
 *        - port   : ushort : the port number to connect to
 */
void handleNetworking(Tid parent, string ipAddr, ushort port)
{
    Client network = new Client(ipAddr, port);

    for (bool active = true; active && network.isSocketOpen();)
    {
        // Checks briefly for messages from main thread.
        auto recv = receiveTimeout(TIMEOUT_DUR, (string packet) {
            // If we get packet info, we will send that along to the server.
            network.sendToServer(packet);
        }, (immutable bool shutdown) {
            // If we receive a shutdown request, we will shutdown this thread.
            writeln("shutting networking thread down upon request");
            active = false;
        }, (OwnerTerminated error) {
            // If our owner thread fails, we will shut down this thread as well.
            writeln("shutting networking thread down upon owner termination");
            active = false;
        }, (Variant any) {
            // In the case of any other packet we will simply log the info.
            writeln(any);
        });

        // Receives information from the server if there is any.
        auto msgAndLen = network.receiveFromServer();

        // When we receive anything from the server, notify our parent thread.
        if (msgAndLen[1] > 0)
        {
            string encodedMsg = to!string(msgAndLen[0]);
            immutable long recvLen = msgAndLen[1];
            writeln(encodedMsg[0 .. recvLen]);
            send(parent, encodedMsg[0 .. recvLen], recvLen);
        }
    }

    destroy(network);
    // Log thread exit.
    writeln("thread has exited");
    
}


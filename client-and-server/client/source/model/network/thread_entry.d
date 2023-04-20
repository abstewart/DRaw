module model.network.thread_entry;

debug
{
    private import std.stdio : writeln;
}
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
            debug
            {
                writeln("Shutting networking thread down upon request from owner.");
            }

            active = false;
        }, (OwnerTerminated error) {
            // If our owner thread fails, we will shut down this thread as well.
            debug
            {
                writeln("Shutting networking thread down upon owner termination.");
            }

            active = false;
        }, (Variant any) {
            // In the case of any other packet we will simply log the information.
            debug
            {
                writeln("Received a message from a thread that was not handled by delegates.");
            }
        });

        // Receives information from the server if there is any.
        auto msgAndLen = network.receiveFromServer();

        // When we receive anything from the server, notify our parent thread.
        if (msgAndLen[1] > 0)
        {
            string encodedMsg = to!string(msgAndLen[0]);
            immutable long recvLen = msgAndLen[1];
            debug
            {
                import std.format;

                writeln("Server -> %s".format(encodedMsg[0 .. recvLen]));
            }

            send(parent, encodedMsg[0 .. recvLen], recvLen);
        }
    }

    destroy(network);
    // Log thread exit.
    debug
    {
        writeln("Networking thread has exited.");
    }
}

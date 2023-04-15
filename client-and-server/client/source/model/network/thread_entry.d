module model.network.thread_entry;

import std.stdio;
import std.string;
import std.conv;
import std.parallelism;
import std.concurrency;
import std.datetime;

import model.network.client;

auto TIMEOUT_DUR = 1.msecs; // timeout for checking interthread messages

/**
 * Runs the main networking loop for the application. 
 * - Checks for messages from main thread
 * - Sends any queued packets
 * - Receives any packets from server
 * - Notifies main thread of received packets
 * 
 * Params:
 *        - parent : Tid : the thread id of the parent thread
 *        - ipAddr : string : the ip address to connect to
 *        - port   : ushort : the port number to connect to
 */ 
void handleNetworking(Tid parent, string ipAddr, ushort port)
{
    writeln(ownerTid());
    Client network = new Client(ipAddr, port);

    for (bool active = true; active && network.isSocketOpen();)
    {
        writeln("checking for message");
        // checks briefly for information to send
        auto recv = receiveTimeout(TIMEOUT_DUR, (string packet) {
            writeln(packet);
            network.sendToServer(packet);
        }, (immutable bool shutdown) {
            writeln("shutting networking thread down upon request");
            active = false;
        }, (OwnerTerminated error) {
            writeln("shutting networking thread down upon owner termination");
            active = false;
        }, (Variant any) { writeln(any); });
        // receives data from our server, note our socket is non-blocking
        auto cmdAndLen = network.receiveFromServer();

        // if we get a command we need to send it to our parent thread
        if (cmdAndLen[1] > 0)
        {
            string encodedCmd = to!string(cmdAndLen[0]);
            immutable long recvLen = cmdAndLen[1];
            writeln(encodedCmd[0 .. recvLen]);
            send(parent, encodedCmd, recvLen);
        }
    }

    writeln("thread has exited");
}

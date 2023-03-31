import std.stdio;
import std.concurrency;
import std.datetime;
import std.string;

void lineReader(Tid owner)
{
    while (true) {
        string line = readln().chomp();
        owner.send(line);
    }
}

void main()
{
    spawn(&lineReader, thisTid);

    while (true) {
        auto received =
            receiveTimeout(3.seconds,
                           (string line) {
                               writefln("Thanks for -->%s<--", line);
                           });

        if (!received) {
            writeln("Patiently waiting...");
        }
    }
}

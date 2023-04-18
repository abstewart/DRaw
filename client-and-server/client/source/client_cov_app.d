private import std.logger;

/** 
 * Provides the coverage library an empty entry point.
 */
void main(string[] args)
{
    auto cLogger = new FileLogger("Client Log File"); // Will only create a new file if one with this name does not already exist.
    cLogger.info("Coverage entry point");
}

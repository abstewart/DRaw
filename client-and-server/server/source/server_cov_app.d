private import std.logger;

/** 
 * Provides the coverage library an empty entry point.
 */
void main(string[] args)
{
    auto sLogger = new FileLogger("Server Log File"); // Will only create a new file if one with this name does not already exist.
    sLogger.info("Coverage entry point");
}

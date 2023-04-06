import std.typecons;

const SKIP_VALUE = -1;

enum Color
{
    NULL = tuple(cast(ubyte) 0, cast(ubyte) 0, cast(ubyte) 0),
    BLUE = tuple(cast(ubyte) 255, cast(ubyte) 128, cast(ubyte) 32)
}

#pragma author xp

import std.mem;

struct PackedKV
{
    u32 cbK;
    u32 cbV;
    char k[cbK];
    u8 v[cbV];
};

PackedKV kvs[while (!std::mem::eof())] @ 0x0;

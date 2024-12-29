#pragma author xp

import type.magic;
import type.size;

import std.io;
import std.mem;
import std.string;

using eol = type::Magic<"\r\n">;

struct KV {
    char16 k[];
    if (sizeof(k) == 2) {
        type::Magic<"\0\0">;
        eol;
        continue;
    }
    eol;
    u8 v[std::mem::find_sequence_in_range(0, $, std::mem::size(), '\r', '\n') - $];
    eol;
};

struct ETW {
    KV items[while (!std::mem::eof())];
};

// skip "ETL\r\n"
ETW etw @ 0x05;

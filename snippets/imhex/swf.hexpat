// https://gist.github.com/xy2i/848eadb61288ecc0cdb19cda7eff79ba
#include "std/core"
#include "std/io"
#include "type/color"
#include "type/magic"
import hex.dec;
import hex.provider;

#pragma pattern_limit 10000000
#pragma array_limit 1000000

bitfield Rect {
    nSize : 5 [[name("N Size")]];
    signed xMin : nSize [[name("X Min")]];
    signed xMax : nSize [[name("X Max")]];
    signed yMin : nSize [[name("Y Min")]];
    signed yMax : nSize [[name("Y Max")]];
};

/* Will always be decompressed regardless of compression used */
struct UncompressedHeader {
    char compressionSignature [[name("Compression"), comment("F - Uncompressed\nC - zlib Compressed\nZ - LZMA compressed")]];
    type::Magic<"WS"> signature [[name("Signature")]];
    u8 swfVersion [[name("SWF Version")]];
    u32 bytesSize [[name("Uncompressed Size")]];
} [[inline]];

struct Header {
    UncompressedHeader;
    be Rect rect [[name("Frame Size"), comment("Needs to be uncompressed to have the correct value.")]];
    padding[1];
    u8 frameRate [[name("Framerate"), comment("Needs to be uncompressed to have the correct value.")]];
    u16 frameCount [[name("Frame Count"), comment("Needs to be uncompressed to have the correct value.")]];
};

enum Tag: u8 {
    End = 0,
    ShowFrame = 1,
    SetBackgroundColor = 9,
    DoAction = 12,
    FileAttributes = 69,
    Metadata = 77, 
};

bitfield RecordHeaderShort {
    Length: 6;
    Tag Tag: 10;
} [[inline]];

struct RecordHeader {
    RecordHeaderShort short [[inline]];
    Tag Tag = short.Tag;
    u32 len = short.Length;
    
    if (short.Length == 0x3f) {
        u32 LongLength;
        len = LongLength;
    }
};

enum Action: u8 {
    Trace = 0x26,
    Push = 0x96,
};

struct ActionPush {
    u8 Type [[hidden]];
    
    match (Type) {
        (0): char String[];
        (1): float Float;
        (4): u8 RegisterNumber;
        (5): bool Boolean;
        (6): double Double;
        (7): u32 Integer;
        (8): u8 Constant8;
        (9): u16 Constant16;
    }
} [[inline]];

struct ActionRecord {
    Action Action;
    
    if (Action >= 0x80) {
        u16 Length;
    }
    
    match (Action) {
        (Action::Push): ActionPush;
        (_): if (Action >= 0x80) {
            u8 unknown[Length];
        }
    }
} [[name(Action)]];

struct SetBackgroundColor {
    type::RGB8 Rgb;
} [[inline]];

struct DoAction {
    ActionRecord records[while(std::mem::read_unsigned($, 1) != 0x00)] [[inline]];
    padding[1]; // null terminator
} [[inline]];

bitfield FileAttributesBitfield {
    padding: 3;
    bool HasMetadata: 1;
    bool ActionScript3: 1;
    padding: 2;
    bool UseNetwork: 1;
} [[inline, bitfield_order(std::core::BitfieldOrder::MostToLeastSignificant, 8)]];

struct FileAttributes {
    FileAttributesBitfield;
    padding[3];
} [[inline]];

struct Metadata {
    char Xml[];
} [[inline]];

struct TagRecord {
    RecordHeader RecordHeader [[inline]];
    
    match (RecordHeader.Tag) {
        (Tag::SetBackgroundColor): SetBackgroundColor;
        (Tag::DoAction): DoAction;
        (Tag::FileAttributes): FileAttributes;
        (Tag::Metadata): Metadata;
        (_): padding[RecordHeader.len];
    } 
} [[name(RecordHeader.Tag)]];

struct File {
    Header;
    TagRecord Tags[while(!std::mem::eof())] [[inline]];
};

struct Compressed {
    UncompressedHeader h;
    std::mem::Section decompressed = std::mem::create_section("Zlib decompressed");
    u8 compressedContents[std::mem::size() - 8] @ 0x8;
    hex::dec::zlib_decompress(compressedContents, decompressed, 15);
    
    std::mem::Section full = std::mem::create_section("Full decompressed SWF");
    std::mem::copy_value_to_section(h, full, 0x0);
    std::mem::copy_section_to_section(decompressed, 0x0, full, 0x8, h.bytesSize - 8);
    // Write decompressed flag, so next time we open the pattern knows it's decompressed
    std::mem::copy_value_to_section("Z", full, 0x0);
    
    u8 d[h.bytesSize] @ 0x00 in full;
    builtin::hex::core::add_virtual_file(std::format("dec-{}", hex::prv::get_information("file_name")), d);
    std::warning("This SWF is ZLib-compressed, grab the decompressed save from\nthe Virtual Filesystem tab and use this pattern on it.");
};

struct Main {
    char compressed @ 0x0 [[hidden]];
    match (compressed) {
        ('C'): Compressed;
        ('Z'): File;
    }
} [[inline]];

Main m @ 0x0;

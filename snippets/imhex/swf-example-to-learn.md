
作者
https://www.xy2i.com/2024/11/using-imhexs-pattern-language-to-parse.html

imHex 官方文档
https://docs.werwolv.net/pattern-language/

以 SWF 文件格式为例，

```rs
import type.magic;

struct Header {
    char compressionSignature;
    type::Magic<"WS"> signature;
    u8 swfVersion;
    u32 bytesSize;
};

Header h @ 0x0;
```

根据已解析的值，决定后续字段布局

```rs
bitfield RecordHeaderShort {
    Length: 6;
    Tag Tag: 10;
};

struct RecordHeader {
    RecordHeaderShort short;
    // 这些变量不是字段，不在视图里，但可以访问
    Tag Tag = short.Tag;
    u32 len = short.Length;

    if (short.Length == 0x3f) {
        u32 LongLength;
        // 变量可以改，之后就可以访问使用它
        len = LongLength;
    }
};
```

```rs
enum Tag: u8 {
    End = 0,
    ShowFrame = 1,
    SetBackgroundColor = 9,
    DoAction = 12,
    FileAttributes = 69,
    Metadata = 77,
};

struct TagRecord {
    RecordHeader RecordHeader;

    match (RecordHeader.Tag) {
        // 字段可以是匿名的，会自动生成一个
        (Tag::SetBackgroundColor): SetBackgroundColor;
        (Tag::DoAction): DoAction;
        (Tag::FileAttributes): FileAttributes;
        (Tag::Metadata): Metadata;
        // 关键字 padding 会被特殊处理，它的值不会出现在视图里
        (_): padding[RecordHeader.len];
    }

// 属性 name 使其在数据面板显示该值，而不是冰冷的结构体名
} [[name(RecordHeader.Tag)]];
```

数组字段，如果不定长，指定一个终止条件

```rs
struct File {
    Header h;
    // 不定长、直到 EOF，都解析为该字段的元素
    TagRecord Tags[while (!std::mem::eof())];
};
```

```rs
// 变量 $ 指向当前解析位置，$ 是可改的；这个例子使 string 遇到 0xFF 时终止
u8 string[while(std::mem::read_unsigned($, 1) != 0xFF)];
```

开辟临时空间执行逻辑，如[解压缩](https://docs.werwolv.net/pattern-language/libraries/hex/dec.pat#hex-dec-zlib_decompress)

```rs
struct Compressed {
    Header h;
    u8 compressed[std::mem::size() - 8] @ 0x8;

    // 执行函数，
    std::mem::Section decompressed = std::mem::create_section("Zlib decompressed");
    hex::dec::zlib_decompress(compressed, decompressed, 15);

    // 重建完整的 SWF 内容（h + decompressed）
    std::mem::Section full = std::mem::create_section("Full SWF");
    std::mem::copy_value_to_section(h, full, 0x0);
    std::mem::copy_section_to_section(decompressed, 0x0, full, 0x8, h.decompressedSize - 8);
    // 修复 full.h.compressionSignature
    std::mem::copy_value_to_section("Z", full, 0x0);

    // VFS https://docs.werwolv.net/pattern-language/libraries/hex/core.pat#hex-core-add_virtual_file
    u8 d[h.bytesSize] @ 0x00 in full;
    builtin::hex::core::add_virtual_file(std::format("dec-{}", hex::prv::get_information("file_name")), d);
    std::warning("Grab the decompressed save from\nthe Virtual Filesystem tab and use this pattern on it.");
};

struct Main {
    char compressed @ 0x0;
    match (compressed) {
        ('C'): Compressed;
        ('Z'): File;
    }
};
```

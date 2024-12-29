
import std.mem;
import type.magic;


struct ChromeCString {
    u32 len;
    char val[len];
    padding[4 - (((sizeof(char) * len) % 4))];
};

struct ChromeWString {
    u32 len;
    char16 val[len];
    padding[4 - (((sizeof(char16) * len) % 4))];
};

struct SerializedToken {
    u64 hi;
    u64 lo;
};

struct IdPayload {
    s32 id;
};

struct OnePayload<T> {
    s32 id;
    T data;
};

using ClosedPayload = OnePayload<s64>; // with time

struct WindowBoundsPayload2 {
    s32 window_id;
    s32 x;
    s32 y;
    s32 w;
    s32 h;
    bool is_maximized;
};

struct WindowBoundsPayload3 {
    s32 window_id;
    s32 x;
    s32 y;
    s32 w;
    s32 h;
    s32 show_state;
};

using IDAndIndexPayload = OnePayload<s32>; // index

using TabIndexInWindowPayload = IDAndIndexPayload;
using TabNavigationPathPrunedFromBackPayload = IDAndIndexPayload;
using SelectedNavigationIndexPayload = IDAndIndexPayload;
using SelectedTabIndexPayload = IDAndIndexPayload;
using WindowTypePayload = IDAndIndexPayload;
using TabNavigationPathPrunedFromFrontPayload = IDAndIndexPayload;
using PinnedStatePayload = OnePayload<bool>; // pinned
using ActiveWindowPayload = IdPayload;
using LastActiveTimePayload = OnePayload<s64>; // time

struct TabNavigationPathPrunedPayload {
    s32 id;
    // entries [index, index + count) were removed
    s32 index;
    s32 count;
};

struct TabGroupPayload {
    s32 tab_id;
    SerializedToken maybe_group;
    bool has_group;
};

using TabStripStatePayload = OnePayload<s32>; // window_id + state
using TabRbiPinnedPayload = IdPayload;

struct SplitScreenPayload {
    s32 main_window_id;
    s32 split_window_id;
    bool split_state;
};

using WindowVisibleOnAllWorkspacesPayload = OnePayload<bool>; // visible

struct SnssTab {
    u32 len;
    s32 id;
    s32 index;
    ChromeCString url;
    ChromeWString title;
    ChromeCString content_state;
    s32 transition_type;
    s32 type_mask;
    ChromeCString referer;
    s32 referer_policy;
};

struct SnssCommand {
    u16 len;
    u8 cmd_id;
    u8 raw[len-1];
};

struct SnssRoot {
    type::Magic<"SNSS"> magic;
    s32 version;
    SnssCommand cmds[while (!std::mem::eof())];
};

SnssRoot root @ 0x0;

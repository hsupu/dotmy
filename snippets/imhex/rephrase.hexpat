
import std.mem;
import protobuf;

struct Navigation {
    Entry virtual_url;
    Entry referrer;
    Entry title;
    Entry;
    Entry unique_id;
    Entry timestamp_mesc;
    Entry;
    Entry;
    Entry;
    Entry global_id;
    Entry http_status_code;
    Entry;
    Entry;
    Entry;
};

struct Tab {
    Entry tab_id;
    Entry window_id;
    Entry tab_visual_index;
    Entry current_navigation_index;
    Entry;
    Entry;
    Entry navigation;
    Navigation @ addressof(navigation.value.data);
    Entry browser_type;
    Entry;
    Entry tab_group_guid;
    Entry tab_guid;
};

Tab tab @ addressof(entries[1].value.data);

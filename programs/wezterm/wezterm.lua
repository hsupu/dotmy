-- https://wezfurlong.org/wezterm/config/files.html
--

-- https://wezfurlong.org/wezterm/config/lua/wezterm/index.html
local wezterm = require "wezterm";

local launch_menu = {}

-- https://wezfurlong.org/wezterm/config/keys.html
local key_bindings = {

}

-- https://wezfurlong.org/wezterm/config/mouse.html
local mouse_bindings = {
    {
        -- 左键选中
        event = { Up = { streak = 1, button = "Left" }},
        mods = "NONE",
        action = wezterm.action{ CompleteSelection = "PrimarySelection" },
    },
    {
        -- CTRL-左键 打开超链接
        event = { Up = { streak = 1, button = "Left" }},
        mods = "CTRL",
        action = "OpenLinkAtMouseCursor",
    },
    {
        -- 右键粘贴
        event = { Down = { streak = 1, button = "Right" }},
        mods = "NONE",
        action = wezterm.action{ PasteFrom = "Clipboard" },
    },
}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then

    table.insert(launch_menu, {
        label = "cmd",
        args = {"cmd.exe", "/s", "/k", "C:/Users/xp/scoop/apps/clink/current/clink.bat", "inject"}
    })

    table.insert(launch_menu, {
        label = "powershell",
        args = {"powershell.exe", "-NoLogo"}
    })

end

-- https://wezfurlong.org/wezterm/config/lua/config/index.html
return {
    -- https://wezfurlong.org/wezterm/config/appearance.html
    color_scheme = "Monokai Remastered",

    default_prog = {"pwsh.exe", "-NoLogo"},
    default_cwd = "C:/my/",

    -- https://wezfurlong.org/wezterm/config/fonts.html
    font = wezterm.font("Iosevka PU-5", {
        weight = "Regular",
    }),

    -- tab bar
    enable_tab_bar = true,
    use_fancy_tab_bar = true,
    hide_tab_bar_if_only_one_tab = false,
    tab_bar_at_bottom = false,

    -- scroll bar
    enable_scroll_bar = true,
    scrollback_lines = 10000,

    -- cursor
    default_cursor_style = "BlinkingBar",
    cursor_blink_rate = 600, -- in ms
    cursor_blink_ease_in = "Constant",
    cursor_blink_ease_out = "Constant",

    launch_menu = launch_menu,

    -- https://wezfurlong.org/wezterm/config/default-keys.html
    disable_default_key_bindings = true,
    keys = key_bindings,
    key_tables = key_tables,

    mouse_bindings = mouse_bindings,
}

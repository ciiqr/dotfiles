local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- font
config.font_size = 16
config.font = wezterm.font("CaskaydiaCove Nerd Font Mono")

-- theme
config.bold_brightens_ansi_colors = false
config.colors = {
    foreground = "#F5F5F4",
    background = "#292524",
    cursor_bg = "#F5F5F4",
    ansi = {
        "#282921",
        "#FF2777",
        "#A3E635",
        "#FDDD6C",
        "#A78BFA",
        "#DB2777",
        "#67E8F9",
        "#F5F5F4",
    },
    brights = {
        "#44403C",
        "#FF6E6E",
        "#BEF264",
        "#FDE68A",
        "#C4B5FD",
        "#EC4899",
        "#A5F3FC",
        "#FAFAF9",
    },
}

config.scrollback_lines = 100000

-- window
-- config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.window_frame = { font = config.font, font_size = config.font_size }

return config

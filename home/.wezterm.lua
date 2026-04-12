local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- font
config.font_size = 16
config.font = wezterm.font("Inconsolata")

-- theme
config.bold_brightens_ansi_colors = false
config.colors = {
    foreground = "#fafaf0",
    background = "#282921",
    cursor_bg = "#fafaf0",
    ansi = {
        "#282921", "#ff2070", "#b0ff11", "#ffc16a",
        "#56e4ff", "#ae81ff", "#91ffef", "#fafaf0"
    },
    brights = {
        "#7b7558", "#ff2070", "#b0ff11", "#ffc16a",
        "#56e4ff", "#ae81ff", "#91ffef", "#faf9f4"
    },
}

-- window
-- config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.window_frame = { font = config.font, font_size = config.font_size }

return config

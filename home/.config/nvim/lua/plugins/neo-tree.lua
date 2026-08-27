return {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
        window = { position = "right", width = 30 },
        filesystem = {
            filtered_items = {
                visible = false,
                hide_gitignored = true,
                hide_dotfiles = false,
                show_hidden_count = false,
                hide_by_pattern = {
                    -- syncthing
                    "**/.stversions",
                    "**/.stfolder",
                },
                never_show_by_pattern = {
                    ".git",
                },
            },
            follow_current_file = { enabled = true },
            hijack_netrw_behavior = "open_current",
        },
        default_component_configs = {
            container = {
                enable_character_fade = false,
            },
        },
    },
}

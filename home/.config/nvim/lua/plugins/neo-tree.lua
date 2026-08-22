return {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
        window = { position = "right", width = 30 },
        filesystem = {
            filtered_items = { visible = true },
            follow_current_file = { enabled = true },
            hijack_netrw_behavior = "open_current",
        },
    },
}

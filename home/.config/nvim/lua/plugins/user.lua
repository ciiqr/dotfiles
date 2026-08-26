---@type LazySpec
return {
    {
        "folke/snacks.nvim",
        opts = {
            dashboard = {
                enabled = false,
            },
            picker = {
                win = {
                    input = {
                        keys = {
                            -- close picker immediately with escape instead of exiting insert mode first, and then exiting
                            ["<Esc>"] = { "close", mode = { "i", "n" } },
                        },
                    },
                },
                ignored = false,
            },
        },
    },
    { -- override nvim-autopairs plugin
        "windwp/nvim-autopairs",
        config = function(plugin, opts)
            -- run default AstroNvim config
            opts.map_cr = false
            require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts)
        end,
    },
}

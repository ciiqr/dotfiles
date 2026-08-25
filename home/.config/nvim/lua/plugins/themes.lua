return {
    { "rktjmp/lush.nvim" },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            signs = false,
            highlight = { after = "", keyword = "fg", multiline = false },
            -- colors = { info = "#ffbd2a" },
            keywords = {
                TODO = { color = "warning" },
                NOTE = { color = "warning" },
                SEE = { color = "warning" },
                SOURCES = { color = "warning" },
                SOURCE = { color = "warning" },
                README = { color = "warning" },
                XXX = { color = "warning" },
                WIP = { color = "warning" },
                FIXME = { color = "error" },
                -- Sigh, https://github.com/folke/todo-comments.nvim/issues/213
                -- ["@todo"] = { color = "warning" },
                -- ["<<<<<<<"] = { color = "error" },
                -- [">>>>>>>"] = { color = "error" },
                -- ["======="] = { color = "error" },
            },
            colors = {
                warning = { "#FDDD6C" },
                error = { "#DB2777" },
            },
        },
    },
    {
        "HiPhish/rainbow-delimiters.nvim",
        config = function()
            require("rainbow-delimiters.setup").setup {
                query = {
                    tsx = "rainbow-parens-custom",
                    typescript = "rainbow-parens-custom",
                    javascript = "rainbow-parens-custom",
                },
                highlight = {
                    "RainbowDelimiterYellow",
                    "RainbowDelimiterPurple",
                    "RainbowDelimiterBlue",
                    "RainbowDelimiterRed",
                    "RainbowDelimiterOrange",
                    "RainbowDelimiterGreen",
                },
            }
        end,
    },
}

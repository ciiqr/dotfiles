return {
    {
        "saghen/blink.cmp",
        opts = {
            keymap = {
                ["<Tab>"] = {
                    function(cmp)
                        if cmp.snippet_active() then
                            return cmp.accept()
                        else
                            return cmp.select_and_accept()
                        end
                    end,
                    "snippet_forward",
                    "fallback",
                },
                ["<S-Tab>"] = { "snippet_backward", "fallback" },
                ["<CR>"] = false,
            },
            completion = {
                list = { selection = { preselect = true, auto_insert = false } },
                menu = {
                    auto_show = true,
                },
                ghost_text = { enabled = true },
                -- accept = { auto_brackets = { enabled = false } },
            },
            sources = {
                default = {
                    "lsp",
                    "path",
                    "snippets",
                    -- "buffer",
                    -- "omni",
                },
            },
        },
    },
    {
        "stevearc/conform.nvim",
        opts = function(_, opts)
            opts.formatters_by_ft = opts.formatters_by_ft or {}
            opts.formatters_by_ft["tex"] = { "tex-fmt" }
            opts.default_format_opts = { lsp_format = "first" }

            opts.format_on_save = function(bufnr)
                if vim.F.if_nil(vim.b[bufnr].autoformat, vim.g.autoformat, true) then
                    return { lsp_format = "first" }
                end
            end

            return opts
        end,
        dependencies = {
            {
                "WhoIsSethDaniel/mason-tool-installer.nvim",
                optional = true,
                opts = function(_, opts)
                    opts.ensure_installed =
                        require("astrocore").list_insert_unique(opts.ensure_installed or {}, { "tex-fmt" })
                end,
            },
        },
    },
    { "rebelot/heirline.nvim", opts = function(_, opts) opts.winbar = nil end },
    { "b0o/schemastore.nvim" },
    {
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
    },
    { "rktjmp/lush.nvim" },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            signs = false,
            highlight = { after = "", keyword = "fg", multiline = false },
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
            require("rainbow-delimiters.setup").setup({
                query = {
                    tsx = "rainbow-parens-custom",
                    typescript = "rainbow-parens-custom",
                    javascript = "rainbow-parens-custom",
                },
                highlight = {
                    "RainbowDelimiterOne",
                    "RainbowDelimiterTwo",
                    "RainbowDelimiterThree",
                    "RainbowDelimiterFour",
                    "RainbowDelimiterFive",
                    "RainbowDelimiterSix",
                },
            })
        end,
    },
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
    {
        "windwp/nvim-autopairs",
        config = function(plugin, opts)
            -- run default AstroNvim config
            opts.map_cr = false
            require("astronvim.plugins.configs.nvim-autopairs")(plugin, opts)
        end,
    },
    {
        "nvimtools/none-ls.nvim",
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    require("none-ls-shellcheck.code_actions").with({
                        extra_filetypes = { "zsh" },
                    }),
                },
            })
        end,
        dependencies = {
            "gbprod/none-ls-shellcheck.nvim",
        },
    },
}

return {
    {
        "saghen/blink.cmp",
        opts = function(_, opts)
            opts.keymap = {
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
            }
            opts.completion = {
                list = { selection = { preselect = true, auto_insert = false } },
                menu = {
                    auto_show = function()
                        -- don't auto show in notes
                        if vim.tbl_contains({ "note" }, vim.bo.filetype) then
                            return false
                        end

                        -- don't auto show in prompt windows
                        if vim.bo.buftype == "prompt" then
                            return false
                        end

                        -- don't auto show in comments and strings
                        local success, node = pcall(vim.treesitter.get_node)
                        if success and node then
                            local node_type = node:type()
                            -- NOTE: it's stinky, I know, not sure what else to
                            -- do other than to handle each language's token
                            -- individually
                            if string.find(node_type, "comment") or string.find(node_type, "string") then
                                return false
                            end
                        end

                        return true
                    end,
                },
                ghost_text = { enabled = true },
                -- accept = { auto_brackets = { enabled = false } },
            }
            opts.sources = {
                default = {
                    "lsp",
                    "path",
                    "snippets",
                    -- "buffer",
                    -- "omni",
                },
            }
        end,
    },
    {
        "stevearc/conform.nvim",
        opts = function(_, opts)
            opts.formatters_by_ft = opts.formatters_by_ft or {}
            opts.formatters_by_ft["tex"] = { "tex-fmt" }
            -- Setup this formatter for all filetypes
            -- opts.formatters_by_ft["*"] = { "trim_newlines" }
            -- Setup this formatter for filetypes that have no other formatters
            opts.formatters_by_ft["_"] = { "trim_newlines" }
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
    {
        "rebelot/heirline.nvim",
        opts = function(_, opts)
            opts.winbar = nil
        end,
    },
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
                sources = {
                    projects = {
                        confirm = function(picker, item)
                            picker:close()
                            if not item then
                                return
                            end
                            local dir = item.file

                            -- Look for a matching session
                            local resession = require("resession")

                            -- If we have a session or we were launched without
                            -- any args, then save before switching
                            local in_session = resession.get_current() ~= nil or vim.fn.argc(-1) == 0
                            if in_session then
                                resession.save(vim.fn.getcwd(), {
                                    dir = "dirsession",
                                    notify = false,
                                })
                            else
                                require("astrocore").config.sessions.autosave.cwd = true
                            end

                            -- If we fail to load that means that a session has
                            -- not yet been initialized for the target directory
                            if not (pcall(resession.load, dir, { dir = "dirsession" })) then
                                -- Clean up current state, then chdir
                                resession.detach()
                                vim.cmd("%bdelete")
                                vim.fn.chdir(dir)
                            end
                        end,
                    },
                },
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
    {
        "package-info.nvim",
        opts = {
            notifications = false,
        },
    },
}

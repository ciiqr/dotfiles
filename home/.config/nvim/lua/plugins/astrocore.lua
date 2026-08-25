local harpoon = require "harpoon"

---@type LazySpec
return {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
        treesitter = {
            ensure_installed = { "sql" },
        },
        diagnostics = {
            severity_sort = true,
        },
        sessions = {
            -- Only save the session if nvim was started with no args
            autosave = {
                cwd = vim.fn.argc(-1) == 0,
            },
        },
        options = {
            opt = {
                clipboard = "",
                undofile = true,
                pumheight = 7,
                completeopt = "menuone,noinsert,popup",
                colorcolumn = "80,120",
                swapfile = false,
                pumborder = "rounded",
                -- showtabline = 0,
                -- smartcase = false,
                -- ignorecase = false,
            },
            g = { undotree_WindowLayout = 3 },
        },
        mappings = {
            i = {
                -- false isn't working to unmap here, so doing a noop instead
                ["<C-x><C-o>"] = "<Nop>",
                ["<Tab>"] = {
                    function() return vim.fn.pumvisible() == 1 and "<CR>" or "<Tab>" end,
                    expr = true,
                    desc = "Accept completion",
                },
                ["<CR>"] = {
                    function()
                        local npairs = require "nvim-autopairs"
                        if vim.fn.pumvisible() ~= 0 then
                            return npairs.esc "<C-e><CR>"
                        else
                            return vim.api.nvim_feedkeys(npairs.autopairs_cr(), "in", false)
                        end
                    end,
                    expr = true,
                    noremap = true,
                    desc = "Newline",
                },
            },
            n = {
                ["<Tab>"] = {
                    function() require("astrocore.buffer").nav(1) end,
                    desc = "Next tab",
                },
                ["<S-Tab>"] = {
                    function() require("astrocore.buffer").nav(-1) end,
                    desc = "Previous tab",
                },
                ["<Leader>fw"] = {
                    function() require("snacks").picker.grep { hidden = true } end,
                    desc = "Find words",
                },
                ["<C-p>"] = {
                    function() require("snacks").picker.files { hidden = true } end,
                    desc = "Find files",
                },
                -- disable harpoon
                ["<Leader><Leader>a"] = false,
                ["<Leader><Leader>e"] = false,
                ["<Leader><Leader>t"] = false,
                ["<Leader><Leader>"] = false,
                -- ganaar
                ["<Leader>a"] = {
                    function() harpoon:list():add() end,
                    desc = "Add harpoon mark",
                },
                ["<C-e>"] = {
                    function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
                    desc = "Open harpoon list",
                },
                ["<Leader>1"] = {
                    function() harpoon:list():select(1) end,
                    desc = "ga naar een",
                },
                ["<Leader>2"] = {
                    function() harpoon:list():select(2) end,
                    desc = "ga naar twee",
                },
                ["<Leader>3"] = {
                    function() harpoon:list():select(3) end,
                    desc = "ga naar drie",
                },
                ["<Leader>4"] = {
                    function() harpoon:list():select(4) end,
                    desc = "ga naar vier",
                },
                ["<Leader>5"] = {
                    function() harpoon:list():select(5) end,
                    desc = "ga naar vijf",
                },
                ["<Leader>6"] = {
                    function() harpoon:list():select(6) end,
                    desc = "ga naar zes",
                },
                -- TODO: remap ganaar window
                -- ["<Leader><Leader><Leader>"] = {
                --     function()
                --         local bufnr = vim.api.nvim_create_buf(false, true)
                --         local width = 60
                --         local height = 10
                --         local row = math.floor(((vim.o.lines - height) / 2) - 1)
                --         local col = math.floor((vim.o.columns - width) / 2)
                --         vim.api.nvim_open_win(bufnr, true, {
                --             title = "ga naar",
                --             relative = "win",
                --             row = row,
                --             col = col,
                --             width = width,
                --             height = height,
                --         })
                --     end,
                -- },
                ["<Leader>P"] = { desc = "Copy path" },
                ["<Leader>Pr"] = {
                    '[[:let @+ = expand("%")<CR>]]',
                    desc = "Copy relative path to current file",
                },
                ["<Leader>Pa"] = {
                    '[[:let @+ = expand("%:p")<CR>]]',
                    desc = "Copy absolute path to current file",
                },
                ["X"] = {
                    function() vim.cmd "!chmod +x %" end,
                    desc = "chmod +X",
                },
            },
        },
    },
}

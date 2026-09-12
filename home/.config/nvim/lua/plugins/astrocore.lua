local harpoon = require("harpoon")

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
            -- AAAAAAAAAAAAAAAAAAHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
            autosave = {
                cwd = vim.fn.argc(-1) == 0,
            },
        },
        options = {
            opt = {
                clipboard = "",
                undofile = true,
                pumheight = 7,
                completeopt = { "menuone", "noinsert", "fuzzy", "preview" },
                colorcolumn = "80,120",
                swapfile = false,
                pumborder = "rounded",
                textwidth = 80,
                scrolloff = 8,
                spell = true,
                -- spell files: https://ftp.nluug.nl/pub/vim/runtime/spell
                spelllang = { "en_ca", "en_us" },
                spelloptions = { "camel" },
                spellfile = vim.fn.stdpath("config") .. "/spell/dictionary.utf-8.add",
            },
            g = { undotree_WindowLayout = 3 },
        },
        mappings = {
            i = {
                -- false isn't working to unmap here, so doing a noop instead
                ["<C-x><C-o>"] = "<Nop>",
                ["<F1>"] = "<Nop>",
                ["<CR>"] = {
                    function()
                        local npairs = require("nvim-autopairs")
                        return vim.api.nvim_feedkeys(npairs.autopairs_cr(), "in", false)
                    end,
                    expr = true,
                    noremap = true,
                    desc = "Newline",
                },
            },
            n = {
                ["<Tab>"] = {
                    function()
                        require("astrocore.buffer").nav(1)
                    end,
                    desc = "Next tab",
                },
                ["<S-Tab>"] = {
                    function()
                        require("astrocore.buffer").nav(-1)
                    end,
                    desc = "Previous tab",
                },
                ["<Leader>fw"] = {
                    function()
                        require("snacks").picker.grep({ hidden = true })
                    end,
                    desc = "Find words",
                },
                -- save
                ["<Leader>w"] = {
                    function()
                        if vim.bo.buftype == "" and vim.api.nvim_buf_get_name(0) == "" then
                            vim.ui.input({ prompt = "Enter filename: " }, function(input)
                                local name = vim.fn.trim(input or "")

                                -- Make sure a name was provided
                                if name == "" then
                                    return
                                end

                                -- Set filename
                                local bufnr = vim.api.nvim_get_current_buf()
                                vim.api.nvim_buf_set_name(bufnr, name)

                                -- Update file type
                                local filetype, on_detect = vim.filetype.match({ buf = bufnr })
                                if filetype ~= nil then
                                    if on_detect ~= nil then
                                        -- NOTE: sets file type specific variables
                                        on_detect(bufnr)
                                    end

                                    vim.bo[bufnr].filetype = filetype
                                end

                                -- Save
                                vim.cmd.write()
                            end)
                        else
                            vim.cmd.write()
                        end
                    end,
                },
                -- neo-tree: always open in the main cwd (not the per-buffer dir)
                ["<Leader>e"] = {
                    function()
                        require("neo-tree.command").execute({
                            toggle = true,
                            dir = vim.fn.getcwd(),
                            reveal = true,
                        })
                    end,
                    desc = "Toggle Explorer",
                },
                ["<Leader>o"] = {
                    function()
                        if vim.bo.filetype == "neo-tree" then
                            vim.cmd.wincmd("p")
                        else
                            require("neo-tree.command").execute({
                                dir = vim.fn.getcwd(),
                                reveal = true,
                                focus = true,
                            })
                        end
                    end,
                    desc = "Toggle Explorer Focus",
                },
                ["<Leader>c"] = {
                    function()
                        local current = vim.api.nvim_get_current_buf()
                        local buffers = vim.tbl_filter(function(buf)
                            return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted
                        end, vim.api.nvim_list_bufs())

                        -- Find the current buffer's position in the buffer list
                        local index
                        for i, buf in ipairs(buffers) do
                            if buf == current then
                                index = i
                                break
                            end
                        end

                        -- If the current buffer isn't in the list, we close
                        -- normally (prompts, help, etc)
                        if index == nil then
                            vim.api.nvim_buf_delete(0, {})
                            return
                        end

                        -- If there's a buffer to the right, select it after closing.
                        -- Otherwise, select the buffer to the left.
                        local target = buffers[index + 1] or buffers[index - 1]

                        require("astrocore.buffer").close(current)

                        if target and vim.api.nvim_buf_is_valid(target) then
                            vim.api.nvim_set_current_buf(target)
                        end
                    end,
                    desc = "Close buffer",
                },
                ["<C-p>"] = {
                    function()
                        require("snacks").picker.files({ hidden = true })
                    end,
                    desc = "Find files",
                },
                -- disable harpoon
                ["<Leader><Leader>a"] = false,
                ["<Leader><Leader>e"] = false,
                ["<Leader><Leader>t"] = false,
                ["<Leader><Leader>"] = false,
                -- ganaar
                ["<Leader>a"] = {
                    function()
                        harpoon:list():add()
                    end,
                    desc = "Add harpoon mark",
                },
                ["<C-e>"] = {
                    function()
                        harpoon.ui:toggle_quick_menu(harpoon:list())
                    end,
                    desc = "Open harpoon list",
                },
                ["<Leader>1"] = {
                    function()
                        harpoon:list():select(1)
                    end,
                    desc = "ga naar een",
                },
                ["<Leader>2"] = {
                    function()
                        harpoon:list():select(2)
                    end,
                    desc = "ga naar twee",
                },
                ["<Leader>3"] = {
                    function()
                        harpoon:list():select(3)
                    end,
                    desc = "ga naar drie",
                },
                ["<Leader>4"] = {
                    function()
                        harpoon:list():select(4)
                    end,
                    desc = "ga naar vier",
                },
                ["<Leader>5"] = {
                    function()
                        harpoon:list():select(5)
                    end,
                    desc = "ga naar vijf",
                },
                ["<Leader>6"] = {
                    function()
                        harpoon:list():select(6)
                    end,
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
                ["<Leader>X"] = {
                    function()
                        vim.cmd("!chmod +x %")
                    end,
                    desc = "chmod +x",
                },
                -- Keep cursor in centre screen while paging up and down
                ["<C-d>"] = "<C-d>zz",
                ["<PageDown>"] = "<C-d>zz",
                ["<C-u>"] = "<C-u>zz",
                ["<PageUp>"] = "<C-u>zz",
                -- Join lines keeping cursor at beginning of line
                ["J"] = "mzJ`z",
                -- Keep search results in centre of screen
                ["n"] = "nzzzv",
                ["N"] = "Nzzzv",
                -- Give it back, precious
                ["<C-x>"] = false,
                ["<Leader>fp"] = {
                    function()
                        require("snacks").picker.projects({
                            format = "file",
                            dev = { "~/Projects", "~/External", "~/pentible", "~/work" },
                            recent = false,
                        })
                    end,
                    desc = "Find projects",
                },
            },
            v = {
                -- Move visual selections up and down
                ["J"] = ":m '>+1<CR>gv=gv",
                ["K"] = ":m '<-2<CR>gv=gv",
            },
        },
    },
}

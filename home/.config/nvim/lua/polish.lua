-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

vim.filetype.add({
    extension = {
        txt = "note",
        todo = "note",
    },
})

vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        -- disable comment continuation
        vim.opt.formatoptions:remove({ "r", "o" })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "note" },
    callback = function()
        vim.opt_local.formatoptions:remove({ "t", "c" })
    end,
})

-- I'll do it myself
vim.api.nvim_create_autocmd("User", {
    pattern = "TSUpdate",
    callback = function()
        local treesitter = require("nvim-treesitter.parsers")
        treesitter.typescript = {
            tier = 0,
            install_info = {
                url = "https://github.com/plewg/tree-sitter-typescript",
                revision = "1a57fed0a1af9523593aca6bc9621f2c5c5c18fb",
                branch = "last_working_version",
                location = "typescript",
            },
        }
        treesitter.tsx = {
            tier = 0,
            install_info = {
                url = "https://github.com/plewg/tree-sitter-typescript",
                revision = "1a57fed0a1af9523593aca6bc9621f2c5c5c18fb",
                branch = "last_working_version",
                location = "tsx",
            },
        }
    end,
})

vim.api.nvim_create_autocmd("VimEnter", {
    desc = "Restore previous directory session if neovim opened with no arguments",
    nested = true,
    callback = function()
        -- Only load the session if nvim was started with no args
        if vim.fn.argc(-1) == 0 then
            -- try to load a directory session using the current working directory
            require("resession").load(vim.fn.getcwd(), {
                dir = "dirsession",
                silence_errors = true,
            })
        end
    end,
})

vim.api.nvim_create_autocmd("CompleteDone", {
    pattern = "*",
    command = "pclose",
})

vim.keymap.set({ "n", "v" }, "<S-Up>", "<Nop>")
vim.keymap.set({ "n", "v" }, "<S-Down>", "<Nop>")
vim.keymap.set({ "n", "v" }, "<F1>", "<Nop>")
vim.keymap.set({ "n", "v", "i" }, "<MiddleMouse>", "<Nop>")
vim.keymap.set({ "n", "v", "i" }, "<2-MiddleMouse>", "<Nop>")
vim.keymap.set({ "n", "v", "i" }, "<3-MiddleMouse>", "<Nop>")
vim.keymap.set({ "n", "v", "i" }, "<4-MiddleMouse>", "<Nop>")

-- horizontal scrolling
vim.keymap.set({ "n", "i", "v" }, "<S-ScrollWheelUp>", "3zh", { desc = "Scroll left" })
vim.keymap.set({ "n", "i", "v" }, "<S-ScrollWheelDown>", "3zl", { desc = "Scroll right" })

function _G.pp(value)
    print(vim.inspect(value))
end

-- TODO: move
---Find the range of the first matching pattern, starting from position.
---@param string string
---@param patterns string[]
---@param position? integer
---@return integer?, integer?
local find_first_matching = function(string, patterns, position)
    for _, pattern in ipairs(patterns) do
        local start_pos, end_pos = string:find(pattern, position)
        if start_pos ~= nil then
            return start_pos, end_pos
        end
    end

    return nil
end

-- Disable spellcheck for certain patterns
local spellcheck_disable_ns = vim.api.nvim_create_namespace("spellcheck_disable_ns")
-- TODO: consider switching to vim regex?
local spellcheck_disable_patterns = {
    -- urls
    -- ie. https://cluod.com (https://cluod.com)cluod https://cluod
    "https?://[^%s()]+",

    -- hex colours (NOTE: lua patterns don't support word boundaries, bounded
    -- repetition, or optional groups, so this is the best we can do)
    -- ie. #FFF #FFFFFF #FFFFFFFF
    "#%x%x%x+",
}
local function spellcheck_disable_update_lines(buf, first_line, last_line)
    local lines = vim.api.nvim_buf_get_lines(buf, first_line, last_line, false)

    for i, line_text in ipairs(lines) do
        local line_num = first_line + i - 1

        local col = 1
        while col <= #line_text do
            -- TODO: ensure fixed with: https://github.com/neovim/neovim/issues/30331
            -- TODO: drop examples (https://cluod.com)cluod https://cluod
            local start_col, end_col = find_first_matching(line_text, spellcheck_disable_patterns, col)
            if not start_col then
                break
            end

            vim.api.nvim_buf_set_extmark(buf, spellcheck_disable_ns, line_num, start_col - 1, {
                end_col = end_col,
                spell = false,
                priority = 200,
            })

            col = end_col + 1
        end
    end
end

vim.api.nvim_create_autocmd("BufEnter", {
    callback = function(args)
        -- Avoid attaching multiple times to the same buffer.
        if vim.b[args.buf].spellcheck_disable_attached then
            return
        end

        vim.b[args.buf].spellcheck_disable_attached = true

        -- apply marks to the whole buffer
        spellcheck_disable_update_lines(args.buf, 0, vim.api.nvim_buf_line_count(args.buf))

        -- re-mark changed lines
        -- TODO: set_decoration_provider might be more efficient (only runs on
        -- visible lines, although, would that break go to next diagnostic?)
        vim.api.nvim_buf_attach(args.buf, false, {
            on_lines = function(_, buf, _, first_line, old_last_line, new_last_line)
                -- clear any existing marks from this region
                vim.api.nvim_buf_clear_namespace(buf, spellcheck_disable_ns, first_line, old_last_line)

                spellcheck_disable_update_lines(buf, first_line, new_last_line)
            end,
        })
    end,
})

-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        -- disable comment continuation
        vim.opt.formatoptions:remove({ "r", "o" })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "note" },
    callback = function() vim.opt_local.formatoptions:remove({ "t", "c" }) end,
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
            require("resession").load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
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

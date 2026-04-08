local vim = vim

vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = true
vim.o.tabstop = 4
vim.o.swapfile = false
vim.g.mapleader = " "
vim.o.signcolumn = "yes"
vim.o.winborder = "single"
vim.o.laststatus = 3
vim.o.colorcolumn = "80,100,120"
vim.opt.fillchars:append({
    eob = " ",
    fold = " ",
    foldopen = "",
    foldsep = " ",
    foldclose = "",
    foldinner = " ",
})

local function format_without_ts()
    vim.lsp.buf.format({
        filter = function(client)
            return client.name ~= "ts_ls"
        end,
        bufnr = vim.api.nvim_get_current_buf(),
    })
end

-- Normal Mode
vim.keymap.set("n", "<leader>so", ":update<CR> :source<CR>")
vim.keymap.set("n", "<leader>w", ":write<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>f", format_without_ts)
vim.keymap.set("n", "<leader>sv", ":vnew<CR>")
vim.keymap.set("n", "<leader>sh", ":new<CR>")
vim.keymap.set({ "n", "v" }, "<leader>ds", ":put =strftime('%Y-%m-%d')<CR>")
vim.keymap.set("n", "<leader>in", ":Inspect<CR>")
vim.keymap.set("n", "-", "<C-x>")
vim.keymap.set("n", "+", "<C-a>")
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "o", "<Nop>")

vim.keymap.set({ "n", "v" }, "<S-Up>", "<Nop>")
vim.keymap.set({ "n", "v" }, "<S-Down>", "<Nop>")
vim.keymap.set({ "n", "v" }, "<F1>", "<Nop>")

-- Copy rel path to current file
vim.keymap.set("n", "<leader>rp", [[:let @+ = expand("%")<CR>]])
vim.keymap.set("n", "<leader>fp", [[:let @+ = expand("%:p")<CR>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Visual Mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<leader>sn", ":!sort -n<CR>")

-- Insert Mode
vim.keymap.set("i", "<Tab>", function()
    return vim.fn.pumvisible() == 1 and "<CR>" or "<Tab>"
end, { silent = true, expr = true })
vim.keymap.set("i", "<CR>", function()
    return vim.fn.pumvisible() == 1 and "<C-e><CR>" or "<CR>"
end, { silent = true, expr = true })

vim.pack.add({
    { src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
    { src = "https://github.com/mbbill/undotree" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/numToStr/Comment.nvim" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/nvim-mini/mini.pick" },
    { src = "https://github.com/nvimtools/none-ls.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/pmizio/typescript-tools.nvim" },
    {
        src = "https://github.com/theprimeagen/harpoon",
        version = "harpoon2",
    },
    { src = "https://github.com/akinsho/toggleterm.nvim" },
    { src = "https://github.com/dracula/vim.git" },
    { src = "https://github.com/Bekaboo/dropbar.nvim" },
    { src = "https://github.com/kevinhwang91/nvim-ufo" },
    { src = "https://github.com/kevinhwang91/promise-async" },
    { src = "https://github.com/nvim-neo-tree/neo-tree.nvim" },
    { src = "https://github.com/MunifTanjim/nui.nvim" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/folke/which-key.nvim" },
    { src = "https://github.com/nvim-mini/mini.completion" },
})

require('mini.completion').setup()

local packagesToDelete = vim.iter(vim.pack.get())
    :filter(function(x)
        return not x.active
    end)
    :map(function(x)
        return x.spec.name
    end)
    :totable()

vim.pack.del(packagesToDelete)

require("ibl").setup()

vim.keymap.set("n", "<leader>u", function()
    vim.cmd.Neotree("close")
    vim.cmd.UndotreeToggle()
end)

local whichKey = require("which-key")
whichKey.setup({ triggers = {} })

vim.keymap.set("n", "<leader>?", function()
    whichKey.show({ global = true })
end)

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("my.lsp", {}),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        if client:supports_method("textDocument/completion") then
            -- Optional: trigger auto-completion on EVERY key press. May be slow!
            client.server_capabilities.completionProvider.triggerCharacters = {
                " ", "!", "\"", "#", "$", "%", "&", "'", "(", ")", "*", "+", ",", "-", ".", "/", "0", "1", "2", "3", "4",
                "5", "6", "7", "8", "9", ":", ";", "<", "=", ">", "?", "@", "A", "B", "C", "D", "E", "F", "G", "H", "I",
                "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "[", "\\", "]", "^",
                "_", "`", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s",
                "t", "u", "v", "w", "x", "y", "z", "{", "|", "}", "~",
            }
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
        end
    end,
})

vim.o.pumheight = 7
vim.o.completeopt = "menuone,noinsert,popup"

require("mini.pick").setup()
-- Only search case sensitive when a capital letter is present in the term
vim.o.ignorecase = true
vim.o.smartcase = true
vim.keymap.set("n", "<leader>pf", ":Pick files<CR>")
vim.keymap.set("n", "<leader>ps", ":Pick grep<CR>")

vim.lsp.config("eslint", {
    settings = {
        problems = {
            shortenToSingleLine = true
        },
        rulesCustomizations = {
            { rule = "*",                          severity = "warn" },
            { rule = "import/no-unused-modules",   severity = "off" },
            { rule = "import-x/no-unused-modules", severity = "off" },
        },
    },
})
vim.lsp.config("*", {
    capabilities = {
        textDocument = {
            foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
            },
        },
    },
})
vim.lsp.config("ts_ls", {
    init_options = {
        preferences = {
            includePackageJsonAutoImports = "on",
            importModuleSpecifierPreference = "non-relative",
        },
    },
})
vim.lsp.enable({ "lua_ls", "eslint", "tailwindcss", "ts_ls", "bashls", "marksman", "prismals" })

-- Theming
vim.cmd(":hi statusline guibg=NONE")
vim.cmd(":hi SignColumn guibg=NONE")
vim.cmd(":hi LineNr guibg=NONE")

vim.cmd("colorscheme dracula")

local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.prettier.with({
            prefer_local = "node_modules/.bin",
            extra_filetypes = { "sh" },
        }),
    },
})

vim.api.nvim_create_autocmd("BufWritePre", {
    callback = format_without_ts,
})

-- -- Does this fuckin do anything??
-- vim.api.nvim_create_autocmd("LspAttach", {
--     callback = function(ev)
--         local client = vim.lsp.get_client_by_id(ev.data.client_id)
--         if client:supports_method("textDocument/completion") then
--             vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
--         end
--     end,
-- })

local status, prettier = pcall(require, "prettier")
if status then
    prettier.setup({
        filetypes = {
            "css",
            "javascript",
            "javacriptreact",
            "typescript",
            "typescriptreact",
            "json",
            "scss",
            "less",
            "markdown",
            "sh",
        },
    })
end

vim.diagnostic.config({
    severity_sort = true,
})

local opts = { remap = false }

-- THESE ARE THE GUYS I ALWAYS FORGET
vim.keymap.set("n", "gd", function()
    vim.lsp.buf.definition()
end, opts)
vim.keymap.set("n", "K", function()
    vim.lsp.buf.hover()
end, opts)
vim.keymap.set("n", "<leader>vws", function()
    vim.lsp.buf.workspace_symbol()
end, opts)
-- SHOW DIAGNOSTICS
vim.keymap.set("n", "<leader>vd", function()
    vim.diagnostic.open_float()
end, opts)
vim.keymap.set("n", "<leader>va", function()
    vim.diagnostic.setloclist()
end, opts)
vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump({ count = 1, float = true })
end, opts)
vim.keymap.set("n", "[d", function()
    vim.diagnostic.jump({ count = -1, float = true })
end, opts)
vim.keymap.set({ "n", "v" }, "<leader>vca", function()
    vim.lsp.buf.code_action()
end, opts)
vim.keymap.set("n", "<leader>vrr", function()
    vim.lsp.buf.references()
end, opts)
vim.keymap.set("n", "<leader>vrn", function()
    vim.lsp.buf.rename()
end, opts)
vim.keymap.set("i", "<C-h>", function()
    vim.lsp.buf.signature_help()
end, opts)

-- Harpoon
local harpoon = require("harpoon")

harpoon:setup()

vim.keymap.set("n", "<leader>a", function()
    harpoon:list():add()
end)
vim.keymap.set("n", "<C-e>", function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
end)

vim.keymap.set("n", "<leader>1", function()
    harpoon:list():select(1)
end)
vim.keymap.set("n", "<leader>2", function()
    harpoon:list():select(2)
end)
vim.keymap.set("n", "<leader>3", function()
    harpoon:list():select(3)
end)
vim.keymap.set("n", "<leader>4", function()
    harpoon:list():select(4)
end)

vim.g.undotree_WindowLayout = 3
vim.opt.termguicolors = true
require("neo-tree").setup({
    window = { position = "right", width = 27 },
    filesystem = {
        filtered_items = { visible = true },
        follow_current_file = { enabled = true },
        hijack_netrw_behavior = "open_current",
    },
})

vim.keymap.set("n", "<leader>pv", function()
    vim.cmd.UndotreeHide()
    vim.cmd(":Neotree toggle reveal")
end)

require("Comment").setup({
    toggler = {
        ---Line-comment toggle keymap
        line = "<C-/>",
        ---Block-comment toggle keymap
        block = "<C-S-/>",
    },
    opleader = {
        ---Line-comment keymap
        line = "<C-/>",
        ---Block-comment keymap
        block = "<C-S-/>",
    },
})

vim.opt.undofile = true

local treesitter_filetypes = {
    "markdown",
    "prisma",
}

require("nvim-treesitter").install(treesitter_filetypes)

for _, v in pairs(treesitter_filetypes) do
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { v },
        callback = function()
            vim.treesitter.start()
        end,
    })
end

require("toggleterm").setup({
    open_mapping = [[<C-\>]],
    direction = "vertical",
    size = 80,
    autochdir = true,
})

vim.cmd(":hi foldcolumn guibg=NONE guifg=White")
vim.cmd(":hi CursorLineFold guibg=NONE guifg=White")
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.opt.foldcolumn = "1"

vim.cmd(":hi Folded guibg=NONE")
require("ufo").setup()

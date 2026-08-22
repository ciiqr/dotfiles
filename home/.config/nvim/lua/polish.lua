-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

vim.api.nvim_create_autocmd("FileType", {
    pattern = "snacks_picker_input",
    callback = function() vim.b.minicompletion_disable = true end,
})

vim.api.nvim_create_autocmd("User", {
    pattern = "TSUpdate",
    callback = function()
        require("nvim-treesitter.parsers").typescript = {
            tier = 0,
            install_info = {
                url = "https://github.com/plewg/tree-sitter-typescript",
                revision = "9c409f23e5e5b830c1387dec520ad4839bccba87",
                branch = "last_working_version",
                location = "typescript",
            },
        }
    end,
})

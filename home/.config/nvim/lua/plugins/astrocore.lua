---@type LazySpec
return {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
        diagnostics = {
            severity_sort = true,
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
                -- smartcase = false,
                -- ignorecase = false,
            },
            g = { undotree_WindowLayout = 3 },
        },
        mappings = {
            i = {
                -- false isn't working to unmap here, so doing a noop instead
                ["<C-x><C-o>"] = function() end,
            },
        },
    },
}

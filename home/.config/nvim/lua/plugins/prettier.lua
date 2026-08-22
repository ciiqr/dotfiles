---@type LazySpec
return {
    {
        "stevearc/conform.nvim",
        opts = function(_, opts)
            if not opts.formatters_by_ft then opts.formatters_by_ft = {} end
            for _, filetype in ipairs {
                "sh",
            } do
                opts.formatters_by_ft[filetype] = { "prettierd" }
            end
        end,
    },
}

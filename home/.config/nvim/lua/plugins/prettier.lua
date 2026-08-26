---@type LazySpec
return {
    {
        "stevearc/conform.nvim",
        opts = function(_, opts)
            if not opts.formatters_by_ft then opts.formatters_by_ft = {} end
            for _, filetype in ipairs({
                "sh",
            }) do
                opts.formatters_by_ft[filetype] = { "prettierd" }
            end

            opts.default_format_opts = { lsp_format = "first" }

            opts.format_on_save = function(bufnr)
                if vim.F.if_nil(vim.b[bufnr].autoformat, vim.g.autoformat, true) then
                    return { lsp_format = "first" }
                end
            end

            return opts
        end,
    },
}

---@type LazySpec
return {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
        mappings = {
            n = {
                ["<Leader>lf"] = { require("conform").format, desc = "Format buffer with Conform" },
            },
        },
        -- Configuration table of features provided by AstroLSP
        features = {
            codelens = false, -- enable/disable codelens refresh on start
            -- inlay_hints = false, -- enable/disable inlay hints on start
            -- semantic_tokens = true, -- enable/disable semantic token highlighting
        },
        -- customize lsp formatting options
        formatting = {
            disabled = { "vtsls", "jsonls", "bashls" },
            timeout_ms = 10000, -- default format timeout
        },
        -- TODO: bashls/shellcheck code actions?
        config = {
            eslint = {
                settings = {
                    rulesCustomizations = {
                        { rule = "*", severity = "warn" },
                        { rule = "import/no-unused-modules", severity = "off" },
                        { rule = "import-x/no-unused-modules", severity = "off" },
                    },
                },
            },
            vtsls = {
                capabilities = {
                    textDocument = {
                        completion = {
                            completionItem = {
                                preselectSupport = true,
                            },
                        },
                    },
                },
                ["js/ts.format.enabled"] = false,
                settings = {
                    typescript = {
                        preferences = {
                            includePackageJsonAutoImports = "on",
                            importModuleSpecifier = "non-relative",
                        },
                    },
                    vtsls = {
                        autoUseWorkspaceTsdk = true,
                    },
                },
            },
            jsonls = {
                settings = {
                    json = {
                        schemas = require("schemastore").json.schemas(),
                    },
                    validate = { enable = true },
                },
            },
        },
    },
}

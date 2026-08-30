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
            timeout_ms = 10000, -- default format timeout
        },
        -- TODO: bashls/shellcheck code actions?
        config = {
            ["*"] = {
                capabilities = {
                    textDocument = {
                        completion = {
                            completionItemKind = {
                                valueSet = {
                                    -- 1, -- Text
                                    2, -- Method
                                    3, -- Function
                                    4, -- Constructor
                                    5, -- Field
                                    6, -- Variable
                                    7, -- Class
                                    8, -- Interface
                                    9, -- Module
                                    10, -- Property
                                    11, -- Unit
                                    12, -- Value
                                    13, -- Enum
                                    14, -- Keyword
                                    15, -- Snippet
                                    16, -- Color
                                    17, -- File
                                    18, -- Reference
                                    19, -- Folder
                                    20, -- EnumMember
                                    21, -- Constant
                                    22, -- Struct
                                    23, -- Event
                                    24, -- Operator
                                    25, -- TypeParameter
                                },
                            },
                        },
                    },
                },
            },
            bashls = {
                -- Disabling here because conform.nvim overrides vim.lsp.buf.format()
                on_attach = function(client)
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                end,
            },
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
                -- Disabling here because conform.nvim overrides vim.lsp.buf.format()
                on_attach = function(client)
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                end,
                capabilities = {
                    textDocument = {
                        completion = {
                            completionItem = {
                                preselectSupport = true,
                            },
                        },
                    },
                },
                settings = {
                    -- I'm not sure this one does anything
                    -- complete_function_calls = true,
                    typescript = {
                        suggest = {
                            completeFunctionCalls = true,
                        },
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
                -- Disabling here because conform.nvim overrides vim.lsp.buf.format()
                on_attach = function(client)
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                end,
                settings = {
                    json = {
                        -- https://github.com/SchemaStore/schemastore/blob/master/src/api/json/catalog.json
                        schemas = require("schemastore").json.schemas({
                            select = {
                                "package.json",
                                "tsconfig.json",
                            },
                        }),
                    },
                    validate = { enable = true },
                },
            },
            yamlls = {
                settings = {
                    yaml = {
                        schemaStore = {
                            enable = false,
                        },
                        schemas = require("schemastore").yaml.schemas({
                            select = {
                                "GitHub Workflow",
                                "docker-compose.yml",
                                "yamllint",
                                "GitHub CLI configuration",
                            },
                        }),
                    },
                },
            },
        },
    },
    specs = {
        { "nvimtools/none-ls.nvim", enabled = false },
    },
}

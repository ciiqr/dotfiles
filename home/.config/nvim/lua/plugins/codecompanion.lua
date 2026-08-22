return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    opts = function(_, opts)
        opts.strategies = {
            chat = { adapter = "lmstudio" },
            inline = { adapter = "lmstudio" },
            cmd = { adapter = "lmstudio" },
        }

        opts.adapters = {
            http = {
                lmstudio = function()
                    return require("codecompanion.adapters").extend("openai_compatible", {
                        name = "lmstudio",
                        formatted_name = "LM Studio",
                        opts = { context_window = 131072 },
                        env = {
                            url = "http://localhost:1234",
                            api_key = "lm-studio",
                            chat_url = "/v1/chat/completions",
                            models_endpoint = "/v1/models",
                        },
                        schema = { model = { default = "google/gemma-4-e4b" } },
                    })
                end,
            },
        }

        opts.opts = { log_level = "DEBUG" }

        return opts
    end,
    -- {
    -- opts = { log_level = "DEBUG" },
    -- interactions = { chat = { adapter = "ollama" }, inline = { adapter = "ollama" } },
    -- adapters = {
    --     http = {
    --         ollama = function()
    --             return require("codecompanion.adapters").extend("openai_compatible", {
    --                 schema = { model = { default = "google/gemma-4-e4b" } },
    --                 env = {
    --                     url = "http://localhost:1234",
    --                 },
    --                 parameters = {
    --                     sync = true,
    --                 },
    --             })
    --         end,
    --     },
    -- },
    --    },
}

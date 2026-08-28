return {
    "echasnovski/mini.completion",
    lazy = false,
    opts = {
        fallback_action = "",
        delay = {
            completion = 100,
            info = 9223372036854775807, -- NOTE: lua 5.1 doesn't have math.maxinteger
        },
    },
}

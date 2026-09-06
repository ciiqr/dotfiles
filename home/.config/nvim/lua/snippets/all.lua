--# selene: allow(unused_variable)
local ls = require("luasnip")

-- NOTE: luasnip imports these automatically with these names... so we just make
-- them proper locals to make the lsp happy
---@diagnostic disable: unused-local
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")
---@diagnostic enable: unused-local

return {
    s(
        "ymd",
        f(function()
            return os.date("%Y-%m-%d")
        end)
    ),
}

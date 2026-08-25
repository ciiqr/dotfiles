-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
    "AstroNvim/astrocommunity",
    { import = "astrocommunity.pack.typescript" },
    { import = "astrocommunity.pack.json" },
    { import = "astrocommunity.pack.lua" },
    { import = "astrocommunity.pack.bash" },
    { import = "astrocommunity.pack.prettier" },
    { import = "astrocommunity.pack.eslint" },
    { import = "astrocommunity.pack.tailwindcss" },
    { import = "astrocommunity.pack.prisma" },
    { import = "astrocommunity.pack.sql" },
    { import = "astrocommunity.motion.nvim-surround" },
    { import = "astrocommunity.motion.harpoon" },
    { import = "astrocommunity.ai.codecompanion-nvim" },
    { import = "astrocommunity.editing-support.conform-nvim" },
    -- { import = "astrocommunity.lsp.lsp-signature-nvim" },
    { import = "astrocommunity.completion.mini-completion" },
    { import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },
}

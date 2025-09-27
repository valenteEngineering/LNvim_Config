-- ~/.config/nvim/lua/LnVim/lsp/servers/clangd.lua


-- This file now directly configures the server using the native API.
-- It will automatically inherit the global on_attach and capabilities.

-- Step 1: Require your shared on_attach and capabilities.
local on_attach = require("LnVim.lsp.attach").on_attach
local capabilities = require("LnVim.lsp.capabilities")

-- Step 2: Configure clangd with the highest priority settings.
vim.lsp.config('clangd', {
    -- Explicitly set your custom functions.
    on_attach = on_attach,
    capabilities = capabilities,

    -- Add your clangd-specific settings.
    cmd = {
        "clangd",
        "--offset-encoding=utf-16",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=bundled",
        "--cross-file-rename",
    },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
})

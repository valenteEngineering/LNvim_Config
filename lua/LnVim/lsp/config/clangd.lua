-- ~/.config/nvim/lua/LnVim/lsp/servers/clangd.lua

-- This file now directly configures the server using the native API.
-- It will automatically inherit the global on_attach and capabilities.

vim.lsp.config('clangd', {
  -- Add any clangd-specific settings here.
  -- The on_attach and capabilities are handled globally and merged automatically.
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


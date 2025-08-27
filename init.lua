require("LnVim")

-- LSP SET UP FOR ALL OF LnVim
-- Load your keymaps and server configs
local lsp_keymaps = dofile(vim.fn.stdpath("config") .. "/after/plugin/lsp.lua")
local pyright_cfg = dofile(vim.fn.stdpath("config") .. "/lsp/pyright.lua")
local ruff_cfg = dofile(vim.fn.stdpath("config") .. "/lsp/ruff.lua")

-- LSP capabilities for cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Inject global options
pyright_cfg.on_attach = lsp_keymaps.on_attach
pyright_cfg.capabilities = capabilities

ruff_cfg.on_attach = lsp_keymaps.on_attach
ruff_cfg.capabilities = capabilities

-- Register and enable LSP servers
vim.lsp.config.pyright = pyright_cfg
vim.lsp.config.ruff_lsp = ruff_cfg

vim.lsp.enable({ "pyright", "ruff" })

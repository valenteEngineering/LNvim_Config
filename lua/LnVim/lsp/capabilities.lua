-- ~/.config/nvim/lua/LnVim/lsp/settings.lua

local M = {}

-- Set up capabilities with nvim-cmp
M.capabilities = require('cmp_nvim_lsp').default_capabilities()

return M

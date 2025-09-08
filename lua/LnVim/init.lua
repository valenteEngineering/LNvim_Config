require("LnVim.remap")
require("LnVim.set")
--require("LnVim.lsp").setup()

-- Plugin Manager 
require("LnVim.lazy")

-- Disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- enable 24-bit colour
vim.opt.termguicolors = false

vim.cmd.colorscheme("retrobox")

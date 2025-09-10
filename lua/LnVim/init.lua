require("LnVim.remap")
require("LnVim.set")
--require("LnVim.lsp").setup()

-- Plugin Manager 
require("LnVim.lazy")

-- Disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Session manager
--vim.o.sessionoptions = "blank,buffers,curdir,folds,help,options,tabpages,winsize,terminal"

-- enable 24-bit colour
vim.opt.termguicolors = true

vim.cmd.colorscheme("cyberdream")

-- Add your global border customizations AFTER the colorscheme
local border_color = "#FF8C00" -- A nice orange, change to your liking
vim.api.nvim_set_hl(0, "WinSeparator", { fg = border_color })

vim.api.nvim_set_hl(0, "StatusLine", {
  fg = "#ffffff",
  bg = "#1e1e2e",
  underline = true,
  sp = "#FF8C00",
})

vim.api.nvim_set_hl(0, "StatusLineNC", {
  fg = "#aaaaaa",
  bg = "#1e1e2e",
  underline = true,
  sp = "#FF8C00",
})

-- GLOBAL LEADER MAPPING
vim.g.mapleader = " "

-- Set GLOBAL keymaps for window navigation
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<C-h>', '<Cmd>wincmd h<CR>', opts)
vim.keymap.set('n', '<C-j>', '<Cmd>wincmd j<CR>', opts)
vim.keymap.set('n', '<C-k>', '<Cmd>wincmd k<CR>', opts)
vim.keymap.set('n', '<C-l>', '<Cmd>wincmd l<CR>', opts)

-- Use Arrow Keys to move between windows
vim.keymap.set('n', '<C-Left>',  '<Cmd>wincmd h<CR>', opts)
vim.keymap.set('n', '<C-Down>',  '<Cmd>wincmd j<CR>', opts)
vim.keymap.set('n', '<C-Up>',    '<Cmd>wincmd k<CR>', opts)
vim.keymap.set('n', '<C-Right>', '<Cmd>wincmd l<CR>', opts)

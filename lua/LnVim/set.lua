-- Set both types of line numbers and format status
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.statuscolumn = "%l %r  "

-- Make all tabs 4 chars 
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Remove vim control of backups, leave that to undotree
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Don't highlight all finds when searching, only the current selection
vim.opt.hlsearch = false
vim.opt.incsearch = true

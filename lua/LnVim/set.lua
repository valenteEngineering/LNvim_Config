-- Set both types of line numbers and format status
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.statuscolumn = "%s %{v:lnum} %{v:relnum} "

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

-- Disable text wrap
vim.opt.wrap = false

-- Create an autocommand group to prevent stacking autocommands on reload
local no_numbers_group = vim.api.nvim_create_augroup("NoNumbersInSpecialBuffers", { clear = true })

-- List of filetypes where we want to disable line numbers
local disable_for_filetypes_set = {
  NvimTree = true,
  terminal = true,
  toggleterm = true,
  lazy = true,
  mason = true,
  help = true,
}

-- Create an autocommand that runs whenever you enter a window
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = buffer_settings_group,
  pattern = "*", -- Run for all buffers
  callback = function()
    -- Check if the current buffer's filetype is in our disable list
    if disable_for_filetypes_set[vim.bo.filetype] then
      -- If it is, disable numbers and the status column for this window
      vim.wo.number = false
      vim.wo.relativenumber = false
      vim.wo.statuscolumn = ""
    else
      -- Otherwise, it's a normal code buffer, so enable our desired settings
      vim.wo.number = true
      vim.wo.relativenumber = true
      vim.wo.statuscolumn = "%s %{v:lnum} %{v:relnum} "
    end
  end,
})

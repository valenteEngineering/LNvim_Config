-- ~/.config/nvim/lua/LnVim/plugins/undotree.lua

-- 1. Set the configuration variables for the plugin
vim.g.undotree_SplitWidth = 40

-- 2. Create the keymaps
-- Keymap for the "smart toggle" to open/focus or switch windows
vim.keymap.set("n", "<leader>u", function()
  if vim.bo.filetype == "undotree" then
    -- If we are in the undotree window, go to the previous window
    vim.cmd("wincmd p")
  else
    -- Otherwise, open and focus the undotree window
    vim.cmd("UndotreeShow")
    vim.cmd("UndotreeFocus")
  end
end, { desc = "Undotree: Focus Toggle" })

-- Keymap for a simple open/close toggle
vim.keymap.set("n", "<leader>U", "<cmd>UndotreeToggle<CR>", { desc = "Undotree: Toggle" })

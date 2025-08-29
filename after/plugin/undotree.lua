-- set the width of the undotree split
vim.g.undotree_SplitWidth = 40

-- <leader>u -> smart open/focus or return to previous window
vim.keymap.set("n", "<leader>u", function()
  -- Check if the current buffer is the undotree buffer
  if vim.bo.filetype == 'undotree' then
    -- If we are in the undotree window, go to the previous window
    vim.cmd('wincmd p')
  else
    -- Otherwise, open and focus the undotree window
    vim.cmd('UndotreeShow')
    vim.cmd('UndotreeFocus')
  end
end, { desc = "Undotree Focus Toggle", noremap = true, silent = true })

-- <leader>U -> normal toggle (open/close)
vim.keymap.set("n", "<leader>U", ":UndotreeToggle<CR>", { desc = "Undotree Toggle", noremap = true, silent = true })

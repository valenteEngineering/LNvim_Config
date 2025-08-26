local last_file_buf = nil
local last_file_path = nil

-- Track last active file buffer (non-NvimTree)
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    if bufname ~= "" and not bufname:match("NvimTree_") then
      last_file_buf = vim.api.nvim_get_current_buf()
      last_file_path = bufname
    end
  end,
})

-- Toggle NvimTree / last file
vim.api.nvim_set_keymap('n', '<leader>e', '', {
  noremap = true,
  silent = true,
  callback = function()
    local api = require('nvim-tree.api')
    local view = require('nvim-tree.view')
    local bufname = vim.api.nvim_buf_get_name(0)

    if bufname:match("NvimTree_") then
      -- Currently in NvimTree: go back to last file
      if last_file_buf and vim.api.nvim_buf_is_valid(last_file_buf) then
        vim.api.nvim_set_current_buf(last_file_buf)
      end
    else
      -- Currently in a file: open/focus NvimTree
      if not view.is_visible() then
        api.tree.open()
      else
        api.tree.focus()
      end

      -- Restore last opened file in the tree
      if last_file_path then
        local ok, node = pcall(api.tree.find_file, last_file_path)
        if ok and node then
          -- Navigate to the node
          api.node.navigate(node)
        end
      end
    end
  end
})




-- ~/.config/nvim/lua/LnVim/plugins/windows.lua

-- 1. SETUP THE PLUGIN
-- We will configure everything inside this one setup block.
require('windows').setup({
    -- Animation settings, as per the documentation
    animation = {
        enable = true,
        duration = 300,
        fps = 30,
        easing = "in_out_sine"
    },

    -- This is the most important part.
    -- It tells autowidth to ignore specific windows.
    ignore = {
        buftype = { 'nofile', 'quickfix', 'terminal' },
        filetype = { 'NvimTree', 'neo-tree', 'undotree', 'telescope', 'TelescopePrompt' },
    },
})

-- 2. KEYMAPS
-- These remain the same.
local function cmd(command)
    return table.concat({ '<Cmd>', command, '<CR>' })
end

vim.keymap.set('n', '<C-w>z', cmd 'WindowsMaximize', { desc = "Windows: Maximize" })
vim.keymap.set('n', '<C-w>_', cmd 'WindowsMaximizeVertically', { desc = "Windows: Maximize Vertically" })
vim.keymap.set('n', '<C-w>|', cmd 'WindowsMaximizeHorizontally', { desc = "Windows: Maximize Horizontally" })
vim.keymap.set('n', '<C-w>=', cmd 'WindowsEqualize', { desc = "Windows: Equalize" })

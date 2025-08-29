local winPicker = require("window-picker")

winPicker.setup({
    hint = 'statusline-winbar',
    selection_chars = 'FJDKSLA;CMRUEIWOQP',
    show_prompt = true,
    prompt_message = 'Pick window: ',
    filter_rules = {
        autoselect_one = false,
        include_current_win = true,
        bo = {
            filetype = { 'NvimTree', 'neo-tree', 'notify' },
            buftype = { 'terminal' },
        },
    },
    highlights = {
        enabled = true,
        statusline = {
            focused = {
                fg = '#5d92f5',
                bg = '#5d92f5',
                bold = true,
            },
            unfocused = {
                fg = '#5d92f5',
                bg = '#5d92f5',
                bold = true,
            },
        },
    },
})

-- Keymap to pick a window with a different hint style
vim.keymap.set('n', '<leader>p', function()
    local picked_window_id = require('window-picker').pick_window({
        hint = 'floating-big-letter'
    })
    if picked_window_id then
        vim.api.nvim_set_current_win(picked_window_id)
    end
end, { desc = 'Pick a window with big letter hint' })

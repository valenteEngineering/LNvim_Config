-- 1. Setup the plugin with its options
require("toggleterm").setup({
  direction = 'horizontal',
  shell = vim.o.shell,
  open_mapping = [[<c-t>]],
  close_on_exit = true,
  start_in_insert = true,
  persist_mode = true,
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
    return 20 -- Default size for floating terminals
  end,
  float_opts = {
    border = 'curved',
    winblend = 0,
  }
})

-- 2. Define custom terminals for frequent tasks
local Terminal = require('toggleterm.terminal').Terminal

-- Lazygit Terminal
local lazygit = Terminal:new({
  cmd = "lazygit",
  dir = vim.fn.getcwd(),
  direction = "float",
  hidden = true, -- Hide from the default ToggleTerm command
  on_open = function(term)
    vim.cmd("startinsert!")
    -- Close lazygit with 'q'
    vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', {noremap = true, silent = true})
  end,
})

-- Node REPL Terminal
local node = Terminal:new({
  cmd = "node",
  hidden = true,
  direction = "float",
})

-- 3. Create the keymaps
local keymap = vim.keymap

-- General terminal toggles
keymap.set("n", "<leader>t", "<cmd>ToggleTerm<CR>", { desc = "ToggleTerm: Toggle" })
keymap.set("n", "<leader>ft", "<cmd>ToggleTerm direction=float<CR>", { desc = "ToggleTerm: Floating" })
keymap.set("n", "<leader>vt", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "ToggleTerm: Vertical" })
keymap.set("n", "<leader>ht", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "ToggleTerm: Horizontal" })

-- Example of Custom terminal toggles
--keymap.set("n", "<leader>gg", function() lazygit:toggle() end, { desc = "ToggleTerm: Lazygit" })
--keymap.set("n", "<leader>nn", function() node:toggle() end, { desc = "ToggleTerm: Node REPL" })

-- 4. Define keymaps for use inside the terminal window
function set_terminal_keymaps()
    local opts = { buffer = 0 }
    -- Exit terminal mode
    keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
    keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
    -- Navigate between windows
    keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
    keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
    keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
    keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)

    keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
    keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
    keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
    keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
end

-- Set the keymaps when a terminal is opened
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

-- ~/.config/nvim/lua/LnVim/plugins/which-key.lua

local whichkey = require("which-key")

-- Configure the which-key pop-up window
whichkey.setup({
  win = {
    -- Customize the border
    border = "double",
    -- Position the window to the far right
    row = 0.25, -- Start 25% from the top
    col = 0.9999,  -- Align to the right edge of the screen
    -- Don't worry about overlapping with other UI elements
    no_overlap = false,
    -- Set a relative width for the window
    width = 0.3,
  },
})

vim.keymap.set("n", "<leader>?", "<cmd>WhichKey<CR>", { desc = "WhichKey: Search Mappings" })

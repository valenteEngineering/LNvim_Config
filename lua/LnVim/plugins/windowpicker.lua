-- ~/.config/nvim/lua/LnVim/plugins/window-picker.lua

-- Create a module table to export our functions
local M = {}

-- Get the plugin's module
local winPicker = require("window-picker")

-- 1. SETUP THE PLUGIN
-- This configures the default behavior and appearance of the picker.
winPicker.setup({
  hint = "statusline-winbar",
  selection_chars = "AOEUIDHTNS",
  show_prompt = true,
  prompt_message = "Pick window: ",
  filter_rules = {
    autoselect_one = true,
    include_current_win = false,
    bo = {
      filetype = { "NvimTree", "neo-tree", "notify" },
      buftype = { },
    },
  },
  highlights = {
    enabled = true,
    statusline = {
      focused = { fg = "#5d92f5", bg = "#5d92f5", bold = true },
      unfocused = { fg = "#5d92f5", bg = "#5d92f5", bold = true },
    },
  },
})

-- 2. CREATE THE FUNCTION FOR YOUR KEYMAP
-- This function will be called by the keymap in lazy.lua.
function M.pick_window_with_big_letter()
  -- It calls the picker with your preferred hint style.
  local picked_window_id = winPicker.pick_window({
    hint = "floating-big-letter",
  })
  -- If a window was successfully picked, switch to it.
  if picked_window_id then
    vim.api.nvim_set_current_win(picked_window_id)
  end
end

-- Return the module so lazy.lua can access the function
return M

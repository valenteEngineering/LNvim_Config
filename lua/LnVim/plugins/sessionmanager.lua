-- This file is called from lazy.lua to configure neovim-session-manager

-- Get the session manager's config module to access options like AutoloadMode
local config = require("session_manager.config")

-- Main setup call for the session manager plugin
require("session_manager").setup({
  -- Automatically save the session on exit and on session switch.
  autosave_last_session = true,

  -- When Neovim starts, first try to load the session for the current directory.
  -- If no session is found, fall back to loading the last saved session.
  autoload_mode = { config.AutoloadMode.CurrentDir, config.AutoloadMode.LastSession },

  -- A few other sensible defaults:
  -- Prevent saving a session when no buffers are open or all are unlisted/unwritable.
  autosave_ignore_not_normal = true,
  -- Don't include buffers of these file types in the session.
  autosave_ignore_filetypes = { 'gitcommit', 'gitrebase' },
})

-- === Autocommands for Custom Behavior ===

-- Create a dedicated, cleared autocommand group for our session manager hooks
local group = vim.api.nvim_create_augroup('LnVimSessionManagerHooks', { clear = true })

-- This command will run automatically AFTER a session has been loaded
vim.api.nvim_create_autocmd({ 'User' }, {
  pattern = "SessionLoadPost",
  group = group,
  callback = function()
    -- Safely check if nvim-tree is available before trying to use it
    local status_ok, nvim_tree = pcall(require, "nvim-tree.api")
    if not status_ok then
      vim.notify("Nvim-tree not found, skipping auto-open.", vim.log.levels.WARN)
      return
    end

    -- Open the file tree
    nvim_tree.tree.open()
  end,
  desc = "Open NvimTree after a session is loaded."
})

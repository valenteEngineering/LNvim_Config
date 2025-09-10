-- ~/.config/nvim/lua/LnVim/plugins/sshfs.lua
-- This is the configuration file for the remote-sshfs.nvim plugin.

local status_ok, sshfs = pcall(require, "remote-sshfs")
if not status_ok then
  vim.notify("remote-sshfs plugin not found", vim.log.levels.WARN)
  return
end

-- Load the telescope extension for remote-sshfs
-- This allows for the picker UI when connecting to hosts.
pcall(require('telescope').load_extension, 'remote-sshfs')

-- Main setup call for the plugin.
-- The configuration below is a generic starting point.
-- You can uncomment and modify options as needed.
sshfs.setup({
  connections = {
    -- Paths to your SSH configuration files.
    -- The plugin will parse these to find available hosts.
    ssh_configs = {
      vim.fn.expand("$HOME") .. "/.ssh/config",
      "/etc/ssh/ssh_config",
    },
    -- Path to your known_hosts file for host key verification.
    ssh_known_hosts = vim.fn.expand("$HOME") .. "/.ssh/known_hosts",

    -- Additional arguments to pass to the sshfs command.
    -- 'reconnect' helps in re-establishing connection if it drops.
    -- 'ConnectTimeout' sets a limit for connection attempts.
    sshfs_args = {
      "-o", "reconnect",
      "-o", "ConnectTimeout=5",
    },
  },
  mounts = {
    -- The base directory where remote filesystems will be mounted locally.
    base_dir = vim.fn.expand("$HOME") .. "/.sshfs/",
    -- Automatically unmount the filesystem when Neovim exits.
    unmount_on_exit = true,
  },
  handlers = {
    on_connect = {
      -- Automatically change Neovim's working directory to the mount point upon connection.
      change_dir = true,
    },
    on_disconnect = {
      -- If set to true, the local mount directory will be removed upon disconnection.
      clean_mount_folders = false,
    },
  },
  ui = {
    confirm = {
      -- Ask for confirmation before connecting to a selected host.
      connect = true,
      -- If 'handlers.on_connect.change_dir' is true, ask before changing the directory.
      change_dir = false,
    },
  },
  log = {
    -- Enable or disable logging for debugging purposes.
    enabled = false,
    -- If true, the log file will be cleared on each startup.
    truncate = false,
    types = {
      all = false,
      util = false,
      handler = false,
      sshfs = false,
    },
  },
})

-- It's recommended to set up keymaps for easier access to the plugin's functionality.
local api = require('remote-sshfs.api')

-- Keymap to open the host selection menu to connect.
vim.keymap.set('n', '<leader>sc', api.connect, { desc = "SSHFS: Connect to host" })

-- Keymap to disconnect from the currently connected host.
vim.keymap.set('n', '<leader>sd', api.disconnect, { desc = "SSHFS: Disconnect from host" })

-- Keymap to open the SSH config file selection menu for editing.
vim.keymap.set('n', '<leader>se', api.edit, { desc = "SSHFS: Edit SSH config" })

-- You can also create dynamic keymaps that use the remote finders when connected,
-- and the standard Telescope finders otherwise.
-- Example:
-- local builtin = require("telescope.builtin")
-- local connections = require("remote-sshfs.connections")
-- vim.keymap.set("n", "<leader>ff", function()
--  if connections.is_connected() then
--   api.find_files()
--  else
--   builtin.find_files()
--  end
-- end, { desc = "Find files (local or remote)" })

-- vim.keymap.set("n", "<leader>fg", function()
--  if connections.is_connected() then
--   api.live_grep()
--  else
--   builtin.live_grep()
--  end
-- end, { desc = "Live grep (local or remote)" })

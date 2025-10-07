require("LnVim.remap")
require("LnVim.set")
--require("LnVim.lsp").setup()

-- System Clipboard
vim.o.clipboard = "unnamedplus"

-- Plugin Manager
require("LnVim.lazy")

-- Disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Session manager
--vim.o.sessionoptions = "blank,buffers,curdir,folds,help,options,tabpages,winsize,terminal"

-- enable 24-bit colour
vim.opt.termguicolors = true

vim.cmd.colorscheme("everforest")

-- Add your global border customizations AFTER the colorscheme
local border_color = "#FF8C00" -- A nice orange, change to your liking
vim.api.nvim_set_hl(0, "WinSeparator", { fg = border_color })

vim.api.nvim_set_hl(0, "StatusLine", {
	fg = "#ffffff",
	bg = "#1e1e2e",
	underline = true,
	sp = "#FF8C00",
})

vim.api.nvim_set_hl(0, "StatusLineNC", {
	fg = "#aaaaaa",
	bg = "#1e1e2e",
	underline = true,
	sp = "#FF8C00",
})

-- In init.lua
vim.api.nvim_create_autocmd("VimEnter", {
	pattern = "*",
	callback = function()
		if vim.bo.filetype == "NvimTree" then
			-- Find the next available window that is not nvim-tree and focus it
			local windows = vim.api.nvim_list_wins()
			for _, win in ipairs(windows) do
				local buf = vim.api.nvim_win_get_buf(win)
				if vim.bo[buf].filetype ~= "NvimTree" then
					vim.api.nvim_set_current_win(win)
					return
				end
			end
		end
	end,
})

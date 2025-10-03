-- ~/.config/nvim/lua/LnVim/nvimtree.lua

local nvimtree = require("nvim-tree")

-- Force NvimTree to its configured width after startup
vim.api.nvim_create_autocmd("UIEnter", {
	callback = function()
		local view = require("nvim-tree.view")
		if view.is_visible() then
			require("nvim-tree.api").tree.resize({ width = 30 })
		end
	end,
})

-- It's good practice to define the on_attach function first
function on_attach(bufnr)
	local api = require("nvim-tree.api")

	-- This is the recommended way to apply the default mappings.
	-- We do this first so we can then selectively disable one.
	api.config.mappings.default_on_attach(bufnr)

	-- Now, we can remove the mapping that we don't want.
	-- This line is the key to the solution.
	vim.keymap.del("n", "<c-t>", { buffer = bufnr })
end

nvimtree.setup({

	sync_root_with_cwd = true,
	respect_buf_cwd = true,

	sort = {
		sorter = "case_sensitive",
	},
	view = {
		width = 30,
	},

	on_attach = on_attach,

	git = {
		enable = true,
		ignore = false,
		timeout = 400,
	},

	-- This tells nvim-tree to monitor the current file and fire the event when ready.
	update_focused_file = {
		enable = true,
		update_root = true, -- Optional, but useful: changes the tree's root to the file's directory
	},
})

-- LENTIL'S CODE TO QUICKLY GO BETWEEN FILE AND NVIMTREE

-- Make required modules local for better performance
local api = require("nvim-tree.api")
local view = require("nvim-tree.view")

-- Declare variables to track the last buffer, making them local to this file
local last_file_buf = nil
local last_file_path = nil

-- 1. Autocmd to track the last active file buffer
vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		local bufname = vim.api.nvim_buf_get_name(0)
		-- Ensure it's a real file and not an NvimTree buffer
		if bufname ~= "" and not bufname:match("NvimTree_") then
			last_file_buf = vim.api.nvim_get_current_buf()
			last_file_path = bufname
		end
	end,
})

-- 2. Keymap to toggle between NvimTree and the last active file
vim.keymap.set("n", "<leader>e", function()
	local current_buf_name = vim.api.nvim_buf_get_name(0)

	if current_buf_name:match("NvimTree_") then
		-- If we are in NvimTree, jump back to the last file
		if last_file_buf and vim.api.nvim_buf_is_valid(last_file_buf) then
			vim.api.nvim_set_current_buf(last_file_buf)
		end
	else
		-- If we are in a regular file, open or focus NvimTree
		if not view.is_visible() then
			api.tree.open()
		else
			api.tree.focus()
		end

		-- After opening, try to find and focus the last active file
		if last_file_path then
			-- Use pcall for safety, in case the file can't be found
			local ok, node = pcall(api.tree.find_file, last_file_path)
			if ok and node then
				api.node.navigate(node)
			end
		end
	end
end, { desc = "NvimTree: Focus Toggle" })

-- 3. A simpler keymap to just toggle the tree's visibility
vim.keymap.set("n", "<leader>E", "<cmd>NvimTreeToggle<CR>", { desc = "NvimTree: Toggle" })

-- 1. Setup the plugin with its options
require("toggleterm").setup({
	direction = "horizontal",
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
		border = "curved",
		winblend = 0,
	},
})

-- 2. Define custom terminals for frequent tasks
local Terminal = require("toggleterm.terminal").Terminal

-- 3. Create the keymaps
local keymap = vim.keymap

-- General terminal toggles
keymap.set("n", "<leader>t", "<cmd>ToggleTerm<CR>", { desc = "ToggleTerm: Toggle" })
keymap.set("n", "<leader>ft", "<cmd>ToggleTerm direction=float<CR>", { desc = "ToggleTerm: Floating" })
keymap.set("n", "<leader>vt", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "ToggleTerm: Vertical" })
keymap.set("n", "<leader>ht", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "ToggleTerm: Horizontal" })
keymap.set("n", "<leader>tt", function()
	-- Get the directory of the current file
	local file_dir = vim.fn.expand("%:p:h")

	-- Use the file's directory if it's a valid directory, otherwise use the current working directory
	local term_dir = (vim.fn.isdirectory(file_dir) == 1) and file_dir or vim.fn.getcwd()

	require("toggleterm.terminal").Terminal:new({ dir = term_dir, direction = "horizontal" }):toggle()
end, { desc = "ToggleTerm: Open NEW terminal in file directory or CWD" })

-- Set the keymaps when a terminal is opened
-- 4. Define keymaps for use inside the terminal window
function set_terminal_keymaps()
	local opts = { buffer = 0 }
	-- Exit terminal mode
	keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
	-- Navigate between windows
	keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
	keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
	keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
	keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)

	keymap.set("t", "<C-Left>", [[<Cmd>wincmd h<CR>]], opts)
	keymap.set("t", "<C-Down>", [[<Cmd>wincmd j<CR>]], opts)
	keymap.set("t", "<C-Up>", [[<Cmd>wincmd k<CR>]], opts)
	keymap.set("t", "<C-Right>", [[<Cmd>wincmd l<CR>]], opts)
end

-- Set the keymaps when a terminal is opened
-- Replace the old vim.cmd line with this:
vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "term://*",
	callback = set_terminal_keymaps, -- Pass the function reference directly
	desc = "Set terminal keymaps",
})

-- Stop NvimTree from stealing focus when ToggleTerm is opened
vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "term://*",
	callback = function()
		-- Find the NvimTree window
		local nvim_tree_win = nil
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local buf_name = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
			if buf_name:match("NvimTree_") then
				nvim_tree_win = win
				break
			end
		end

		-- If NvimTree window is found, prevent it from being focused
		if nvim_tree_win then
			vim.cmd("noautocmd wincmd p") -- Switch to previous window without triggering autocommands
			vim.cmd("wincmd p") -- Switch back to the terminal window
		end
		-- Optional: a more direct way to ensure focus stays on the terminal
		-- This might be needed if the above doesn't work consistently
		vim.cmd("startinsert")
	end,
	desc = "Prevent NvimTree from stealing focus from ToggleTerm",
})

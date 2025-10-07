-- ~/.config/nvim/lua/LnVim/plugins/project.lua

local M = {}

-- This is the main setup function that will be called by lazy.nvim
function M.setup()
	-- 1. CONFIGURE THE PLUGIN
	require("project_nvim").setup({
		detection_methods = { "pattern", "lsp" },
		patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", ".nvim-project" },
		manual_mode = false,
	})

	-- 2. DEFINE ALL PROJECT-RELATED KEYMAPS HERE

	-- Keymap to build/run the project

	vim.keymap.set("n", "<leader>b", function()
		--print("--starting projects")
		local project_root = vim.fn.getcwd()
		if not project_root or project_root == "" then
			--print("Error: Not inside a recognized project.")
			return
		end

		local config_path = project_root .. "/.nvim-project"

		if vim.fn.filereadable(config_path) == 0 then
			--print("Error: No .nvim-project file found in the project root.")
			return
		end

		local file = io.open(config_path, "r")
		if not file then
			--print("Error: Could not open .nvim-project file.")
			return
		end
		local content = file:read("*a")
		file:close()

		local ok, config = pcall(vim.fn.json_decode, content)
		if not ok or type(config) ~= "table" then
			--print("Error: Failed to parse JSON from .nvim-project file.")
			return
		end

		--print("DEBUG: Printing the entire 'config' table parsed from JSON:")
		--vim.print(config)

		local build_cmd = config.project_build_command
		local build_dir = config.project_work_dir

		if not build_cmd then
			print("Error: 'project_build_command' key not found in the config table.")
			return
		end

		if not build_dir then
			print("Error: 'project_work_dir' key not found in the config table.")
			return
		end

		if type(build_cmd) ~= "string" then
			print("Error: 'project_build_command' is not a string. Type is: " .. type(build_cmd))
			return
		end

		if type(build_dir) ~= "string" then
			print("Error: 'project_build_command' is not a string. Type is: " .. type(build_dir))
			return
		end

		if build_cmd ~= "" then
			local term_cmd = string.format('9TermExec cmd="%s" dir=%s', build_cmd, build_dir)
			vim.cmd(term_cmd)
		end
	end, { desc = "Build: Run project-specific command" })

	-- A second, useful keymap: Find files only within the current project.
	vim.keymap.set("n", "<leader>pf", function()
		local project_root = require("project_nvim").get_project_root()
		if not project_root then
			-- If not in a project, just find files normally from the current directory
			require("telescope.builtin").find_files()
			return
		end
		-- If in a project, tell Telescope to search only from the project's root
		require("telescope.builtin").find_files({
			cwd = project_root,
		})
	end, { desc = "Project: Find files in project" })
end

return M

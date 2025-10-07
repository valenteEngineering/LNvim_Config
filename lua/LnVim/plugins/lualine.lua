local colors = {
	red = "#ca1243",
	grey = "#a0a1a7",
	black = "#383a42",
	white = "#f3f3f3",
	light_green = "#83a598",
	orange = "#e05e5e",
	green = "#8ec07c",
}

local theme = {
	normal = {
		a = { fg = colors.white, bg = colors.black },
		b = { fg = colors.white, bg = colors.grey },
		c = { fg = colors.black, bg = colors.orange },
		x = { fg = colors.black, bg = colors.orange },
		y = { fg = colors.black, bg = colors.orange },
		z = { fg = colors.white, bg = colors.black },
	},
	insert = { a = { fg = colors.black, bg = colors.light_green } },
	visual = { a = { fg = colors.black, bg = colors.orange } },
	replace = { a = { fg = colors.black, bg = colors.green } },
}

local empty = require("lualine.component"):extend()
function empty:draw(default_highlight)
	self.status = ""
	self.applied_separator = ""
	self:apply_highlights(default_highlight)
	self:apply_section_separators()
	return self.status
end

-- Put proper separators and gaps between components in sections
local function process_sections(sections)
	for name, section in pairs(sections) do
		local left = name:sub(9, 10) < "x"
		for pos = 1, name ~= "lualine_z" and #section or #section - 1 do
			table.insert(section, pos * 2, { empty, color = { fg = colors.orange, bg = colors.orange } })
		end
		for id, comp in ipairs(section) do
			if type(comp) ~= "table" then
				comp = { comp }
				section[id] = comp
			end
			comp.separator = left and { right = "" } or { left = "" }
		end
	end
	return sections
end

local function search_result()
	if vim.v.hlsearch == 0 then
		return ""
	end
	local last_search = vim.fn.getreg("/")
	if not last_search or last_search == "" then
		return ""
	end
	local searchcount = vim.fn.searchcount({ maxcount = 9999 })
	return last_search .. "(" .. searchcount.current .. "/" .. searchcount.total .. ")"
end

local function modified()
	if vim.bo.modified then
		return "+"
	elseif vim.bo.modifiable == false or vim.bo.readonly == true then
		return "-"
	end
	return ""
end

local function lsp_client_names()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		return ""
	end
	local client_names = {}
	for _, client in ipairs(clients) do
		table.insert(client_names, client.name)
	end
	return "󰒋 " .. table.concat(client_names, ", ")
end

-- ===================================================================
-- NEW FUNCTION: Get filename from nvim-tree API
-- ===================================================================
local function nvim_tree_filename()
	-- Use pcall (protected call) to safely require the nvim-tree API.
	-- This prevents errors if nvim-tree is not loaded.
	local success, api = pcall(require, "nvim-tree.api")
	if not success or not api then
		return ""
	end

	-- Get the node under the cursor
	local node = api.tree.get_node_under_cursor()

	-- If a node is found, return its name. Otherwise, return an empty string.
	if node and node.name then
		-- You could add an icon here, for example: return " " .. node.name
		return node.name
	end
	return ""
end
-- ===================================================================

require("lualine").setup({
	options = {
		theme = theme,
		component_separators = "",
		section_separators = { left = "", right = "" },
	},
	sections = process_sections({
		lualine_a = { "mode" },
		lualine_b = {
			"branch",
			{ "filename", file_status = true, path = 1 },
			{ modified, color = { bg = colors.red } },
			{
				"%w",
				cond = function()
					return vim.wo.previewwindow
				end,
			},
			{
				"%r",
				cond = function()
					return vim.bo.readonly
				end,
			},
			{
				"%q",
				cond = function()
					return vim.bo.buftype == "quickfix"
				end,
			},
		},
		lualine_c = {},
		lualine_x = { search_result, "filetype" },
		lualine_y = { lsp_client_names, "lsp_progress" },
		lualine_z = { "%p%%" },
	}),
	inactive_sections = {
		lualine_c = { "%f %y %m" },
		lualine_x = {},
	},
	-- MODIFIED EXTENSION SECTION
	extensions = {
		{
			filetypes = { "NvimTree" },
			sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { nvim_tree_filename }, -- Use our new function here
				lualine_x = {},
				lualine_y = {},
				lualine_z = {}, -- Keep line number/percentage on the right
			},
			inactive_sections = {
				lualine_c = { nvim_tree_filename },
				lualine_z = {},
			},
		},
	},
})

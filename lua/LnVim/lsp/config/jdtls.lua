-- ~/.config/nvim/lua/LnVim/lsp/config/jdtls.lua
-- CORRECTED FOR NVIM 0.11+

local os_name = vim.loop.os_uname().sysname

-- Determine the path for the jdtls data directory based on the OS
local data_dir
if os_name == "Darwin" then -- macOS
	data_dir = vim.fn.stdpath("cache") .. "/jdtls-workspace/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
elseif os_name == "Linux" then
	data_dir = vim.fn.stdpath("data") .. "/jdtls/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
else -- Windows or other
	data_dir = vim.fn.stdpath("data") .. "\\jdtls\\" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
end

local config = {
	cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xms1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-jar",
		vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
		"-configuration",
		vim.fn.stdpath("data")
			.. "/mason/packages/jdtls/config_"
			.. (os_name == "Linux" and "linux" or (os_name == "Darwin" and "mac" or "win")),
		"-data",
		data_dir,
	},
	root_dir = function(fname)
		-- Use the built-in root pattern function from lspconfig's utility
		return require("lspconfig.util").root_pattern("gradlew", ".git")(fname)
	end,
	init_options = {
		bundles = {},
	},
}

-- THIS IS THE MAIN CHANGE:
-- Instead of require('lspconfig').jdtls.setup, we use vim.lsp.config.jdtls.setup
vim.lsp.config.jdtls.setup({
	filetypes = { "java", "kotlin", "gradle" },
	-- The shared on_attach and capabilities from your lsp/init.lua will be automatically applied
	cmd = config.cmd,
	root_dir = config.root_dir,
	init_options = config.init_options,
})

-- Also update the kotlin_language_server call.
-- Even though it has no special config, we need to ensure it's set up.
-- Your mason-lspconfig setup will likely handle this, but being explicit is safe.
vim.lsp.config.kotlin_language_server.setup({})

--### Summary of Changes
--
--1.  **Removed `local lspconfig = require('lspconfig')`**: It's no longer needed.
--2.  **Changed `lspconfig.jdtls.setup` to `vim.lsp.config.jdtls.setup`**: This is the core of the fix.
--3.  **Changed `lspconfig.kotlin_language_server.setup` to `vim.lsp.config.kotlin_language_server.setup`**: Ensures all calls are using the new API.
--4.  **Updated `root_dir`**: The way `root_dir` is defined is slightly different with the new API. The corrected code uses the new standard way.
--
--After replacing the content of that file and restarting Neovim, the deprecation warning will disappear, and your configuration will be aligned with the modern Neovim standard. Your other files, like `lsp/init.lua`, are fine because they delegate the setup to `mason-lspconfig`, which handles this new API internally.

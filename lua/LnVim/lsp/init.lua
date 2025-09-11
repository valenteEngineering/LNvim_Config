-- ~/.config/nvim/lua/LnVim/lsp/init.lua

local M = {}

-- This function is called from your lazy.lua to set up everything.
function M.setup()
    -- Step 1: Get our shared settings for on_attach and capabilities.
    -- This makes it easy to apply the same keymaps and completion settings to all LSPs.
    local capabilities = require("LnVim.lsp.capabilities")
    local on_attach = require("LnVim.lsp.attach")

    -- Step 2: Set the global default configuration for all LSP servers.
    -- Neovim's LSP client will automatically use these settings for every server
    -- unless a server-specific config overrides them.
    vim.lsp.config('*', {
        capabilities = capabilities,
        on_attach = on_attach,
    })

    -- Step 3: Define the list of LSP servers you want to use.
    -- This list is used by mason-lspconfig to ensure they are installed.
    local servers = {
        "lua_ls",
        "clangd",
        "pyright",
        -- Add other servers here, for example: "pyright", "rust_analyzer"
    }

    -- Step 4: Load any custom server configurations from the `lsp/servers` directory.
    -- This loop tries to load a config file for each server in the list.
    -- Using `pcall` (protected call) prevents errors if a config file doesn't exist.
    for _, server_name in ipairs(servers) do
        pcall(require, "LnVim.lsp.config." .. server_name)
    end

    -- Step 5: Configure mason and mason-lspconfig.
    -- 2. CONFIGURE MASON TO INSTALL YOUR TOOLS
    require("mason").setup({
        -- This is where you tell Mason what tools to install.
        -- We add ruff here. Pyright will be handled by mason-lspconfig.
        ensure_installed = {
            "ruff",   -- For Python linting and formatting
            "stylua", -- Optional: for formatting Lua code
        }
    })

    -- 3. CONFIGURE MASON-LSPCONFIG
    -- This ensures the servers in your `servers` list are installed
    -- and automatically configured for nvim-lspconfig.
    require("mason-lspconfig").setup({
        ensure_installed = servers,
    })
end

return M

-- ~/.config/nvim/lua/LnVim/plugins/lsp.lua

-- Setup for mason.nvim
require("mason").setup()

-- Setup for mason-lspconfig.nvim
-- This bridge plugin makes sure LSPs installed with Mason are configured with nvim-lspconfig.
require("mason-lspconfig").setup({
    -- A list of servers to automatically install if they're not already installed
    ensure_installed = { "lua_ls",  "pyright" },
})

-- Central nvim-lspconfig setup
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities() -- Capabilities provided by nvim-cmp

-- Keymaps for LSP actions
-- This function will be called once for each LSP server that attaches to a buffer.
local on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    -- Set keymaps using the 'opts' table
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)          -- Go to definition
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)                -- Show hover documentation
    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts) -- Workspace symbols
    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)    -- Show line diagnostics
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)        -- Go to previous diagnostic
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)        -- Go to next diagnostic
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)  -- Code actions
    vim.keymap.set("n", "<leader>rr", vim.lsp.buf.rename, opts)      -- Rename symbol
end

-- Get the list of installed servers
local servers = require("mason-lspconfig").get_installed_servers()

-- Loop through the servers and set them up with the shared config
for _, server_name in ipairs(servers) do
    lspconfig[server_name].setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
end

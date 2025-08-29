-- ~/.config/nvim/lua/LnVim/lsp.lua

-- This is the main LSP configuration module for your LnVim setup.
local M = {}

-- Part 1: Define the 'on_attach' function
-- This function contains all the keymaps and settings that will be
-- applied to every language server that starts.
local on_attach = function(client, bufnr)
    -- A message to confirm which server has started
    print("LSP client attached: " .. client.name)

    -- Standard options for keymaps
    local opts = { noremap=true, silent=true, buffer=bufnr }

    -- Keymaps for LSP functionality
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts) -- Go to implementation
    --vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)     -- Show references
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)

    -- Keymaps for navigating diagnostics (errors, warnings)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

    -- Toggle the line or text diagnostic messages
    vim.keymap.set('n', '<leader>gn', function()
        local current = vim.diagnostic.config()
        if current.virtual_text then
            vim.diagnostic.config({
                virtual_text = false,
                virtual_lines = true
            })
        else
            vim.diagnostic.config({
                virtual_text = true,
                virtual_lines = false
            })
        end
    end, opts)
end


-- Part 2: The main setup function
-- This function will be called from your framework's main init.lua
function M.setup()
    -- Get the necessary libraries
    local lspconfig = require("lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities() -- For nvim-cmp autocompletion

    -- =============================================
    --  SERVER CONFIGURATIONS
    -- =============================================

    -- Python
    lspconfig.pyright.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    lspconfig.ruff.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    -- C/C++
    lspconfig.clangd.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    -- LUA
    lspconfig.lua_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    -- You can add more servers here in the future
    -- lspconfig.gopls.setup({ ... })
    -- lspconfig.tsserver.setup({ ... })

end


-- Part 3: Setup the the visuals for when editing
vim.diagnostic.config({
  virtual_text = true,      -- turn off inline text
  virtual_lines = false,      -- show full diagnostics as virtual lines below
  signs = true,
  underline = true,
})

-- This line makes the M.setup() function available to other files
return M

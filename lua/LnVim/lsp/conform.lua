-- ~/.config/nvim/lua/LnVim/plugins/conform.lua

local M = {}

require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format", "isort" }, -- Use ruff and isort for python
        cpp = { "clang-format" },
        c = { "clang-format" },
        -- You can add other languages here
        -- javascript = { "prettier" },
    },

    -- Optional: Set up format on save
    format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
    },
})

-- Optional: Add a keymap to format the buffer manually
vim.keymap.set({ "n", "v" }, "<leader>f", function()
    require("conform").format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 500,
    })
end, { desc = "Format buffer" })

return M

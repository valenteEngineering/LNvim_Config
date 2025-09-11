-- ~/.config/nvim/lua/LnVim/plugins/lint.lua
local M = {}

local lint = require("lint")

lint.linters_by_ft = {
    python = { "ruff" },
    cpp = { "clang-tidy" },
    c = { "clang-tidy" }

    -- You can add other languages here
    -- lua = { "luacheck" }
}

-- Set up linting to run automatically on specific events
vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
    callback = function()
        lint.try_lint()
    end,
})

return M

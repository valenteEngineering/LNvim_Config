local lazygit = require("lazygit")

-- Global mapping
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>", { noremap = true, silent = true })

-- will need to look at docs for neovim-remote

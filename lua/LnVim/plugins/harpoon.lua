-- ~/.config/nvim/lua/LnVim/plugins/harpoon.lua

local harpoon = require("harpoon")

-- REQUIRED: setup harpoon
harpoon:setup({})

-- Basic Keymaps
vim.keymap.set("n", "<leader>a", function() harpoon:list():add() print("Harpooned file") end, { desc = "Harpoon: Add file" })
vim.keymap.set("n", "<leader>d", function() harpoon:list():remove() print("Removed file") end, { desc = "Harpoon: Remove file" })

-- Navigation Keymaps
--vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end, { desc = "Harpoon: Go to file 1" })
--vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end, { desc = "Harpoon: Go to file 2" })
vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end, { desc = "Harpoon: Go to file 3" })
vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end, { desc = "Harpoon: Go to file 4" })

-- Telescope Integration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for i = 1, #harpoon_files.items do
        local item = harpoon_files.items[i]
        if item then
            table.insert(file_paths, item.value)
        end
    end

    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end

vim.keymap.set("n", "<C-\\>", function() toggle_telescope(harpoon:list()) end, { desc = "Harpoon: Open Telescope" })

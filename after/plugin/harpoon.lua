-- require the necessary plugins
local harpoon = require("harpoon")
local conf = require("telescope.config").values

-- REQUIRED: setup harpoon
harpoon:setup({})

-- 1. Add current file to harpoon
vim.keymap.set("n", "<leader>a", function()
    harpoon:list():add()
    print("Harpooned file")
end, { desc = "Harpoon: Add file" })

-- 2. Remove current file from harpoon
vim.keymap.set("n", "<leader>d", function()
    harpoon:list():remove()
    print("Removed file from Harpoon")
end, { desc = "Harpoon: Remove file" })

-- 3. Telescope UI for harpoon (with the fix)
local function toggle_telescope(harpoon_files)
    local file_paths = {}
    -- Use a standard indexed loop to handle `nil` values correctly
    for i = 1, #harpoon_files.items do
        local item = harpoon_files.items[i]
        -- Check if the item exists before adding its value to the list
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

-- Lentil keymap for opening list
vim.keymap.set("n", "<C-\\>", function()
    toggle_telescope(harpoon:list())
end, { desc = "Harpoon: Open menu" })

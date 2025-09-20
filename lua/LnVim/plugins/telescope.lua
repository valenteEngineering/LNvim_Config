-- ~/.config/nvim/lua/LnVim/plugins/telescope.lua

-- Make modules local for better performance
local telescope = require("telescope")
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local nvim_tree_api = require("nvim-tree.api")

-- 1. SETUP TELESCOPE AND LOAD EXTENSIONS
-- This must be done first.
telescope.setup({
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
        },
    },
    defaults = {
        -- This is the section you need to add or modify
        mappings = {
            i = { -- 'i' for insert mode, which is the default mode in Telescope
                -- Map Shift-Enter to open in a vertical split
                ["<S-CR>"] = actions.select_vertical,

                -- For reference, the default Enter mapping is this:
                ["<CR>"] = actions.select_default,
            },
            n = { -- 'n' for normal mode in Telescope
                ["<S-CR>"] = actions.select_vertical,
            }
        }

    },

    pickers = {
        find_files = {
            find_command = { 'rg', '--files', '--no-ignore-vcs', '--hidden' },
        },
    },
})
telescope.load_extension("ui-select")

function map_split_actions(picker_func)
    return function()
        picker_func({
            attach_mappings = function(prompt_bufnr, map)
                -- This function runs for this specific picker instance.
                -- It adds our desired mapping.
                map("i", "<S-CR>", actions.select_vertical)
                map("n", "<S-CR>", actions.select_vertical)

                -- CRITICAL: return true to also load all the default mappings
                return true
            end,
        })
    end
end

-- 2. STANDARD KEYMAPS
vim.keymap.set("n", "<leader>ff", map_split_actions(builtin.find_files), { desc = "Telescope: Find files" })
vim.keymap.set("n", "<leader>fg", map_split_actions(builtin.live_grep), { desc = "Telescope: Live grep" })
vim.keymap.set("n", "<leader>fb", map_split_actions(builtin.buffers), { desc = "Telescope: Buffers" })
vim.keymap.set("n", "<leader>fk", map_split_actions(builtin.keymaps), { desc = "Telescope: Keymaps" })
vim.keymap.set("n", "<leader>fd", "<cmd>Telescope diagnostics<CR>", { desc = "Telescope: Diagnostics" })
vim.keymap.set("n", "<leader>cc", map_split_actions(builtin.colorscheme), { desc = "Telescope: Colorscheme" })


-- 3. LENTIL'S "PROJECT SIDESCOPE" IMPLEMENTATION
-- This section contains your custom logic for directory-scoped searching.

-- Define your project's important directories.
local project_hotlist = {
    { display = "YOCTO_BUILD_DIR",     path = "/home/alexvalente/CompulabQtYocto/build-imx8mm-lpddr4-evk/tmp/deploy/images/imx8mm-lpddr4-evk" },
    { display = "YOCTO_KERNEL_DIR",    path = "/home/alexvalente/CompulabQtYocto/build-imx8mm-lpddr4-evk/tmp/work-shared/imx8mm-lpddr4-evk/kernel-source" },
    { display = "ATTOLLO_META_LAYER",  path = "/home/alexvalente/CompulabQtYocto/sources/meta-attolloVasRf" },
    { display = "YOCTO_MEDIA_DRIVERS", path = "/home/alexvalente/CompulabQtYocto/build-imx8mm-lpddr4-evk/tmp/work-shared/imx8mm-lpddr4-evk/kernel-source/drivers/media" },
    { display = "META_SOURCES",        path = "/home/alexvalente/CompulabQtYocto/sources" },
}

-- The picker function for changing the current working directory
local function project_hotlist_picker()
    -- (Your implementation is copied here exactly)
    local max_width = 0
    for _, item in ipairs(project_hotlist) do
        if #item.display > max_width then
            max_width = #item.display
        end
    end
    max_width = max_width + 2
    require("telescope.pickers").new({}, {
        prompt_title = "Project Hotlist",
        finder = require("telescope.finders").new_table({
            results = project_hotlist,
            entry_maker = function(entry)
                local format_string = "%-" .. tostring(max_width) .. "s | %s"
                return {
                    value = entry.path,
                    display = string.format(format_string, entry.display,
                        vim.fn.fnamemodify(entry.path, ":~")),
                    ordinal = entry.display .. " " .. entry.path
                }
            end,
        }),
        sorter = require("telescope.config").values.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                local path = selection.value
                vim.cmd.cd(path)
                nvim_tree_api.tree.change_root(path)
                print("Changed directory to: " .. path)
            end)
            return true
        end,
    }):find()
end

-- The generator function that creates your two-stage picker workflow
local function create_scoped_picker_workflow(config)
    -- This function remains mostly the same, only the innermost action changes.
    local workflow_func = nil
    workflow_func = function(opts)
        opts = opts or {}
        local initial_query = opts.query or ""
        require("telescope.pickers").new({}, {
            prompt_title = "Select Search Directory",
            finder = require("telescope.finders").new_table({
                results = project_hotlist,
                entry_maker = function(entry)
                    local max_width = 0
                    for _, item in ipairs(project_hotlist) do
                        if #item.display > max_width then
                            max_width = #item.display
                        end
                    end
                    max_width = max_width + 2
                    local format_string = "%-" .. tostring(max_width) .. "s | %s"
                    return {
                        value = entry.path,
                        display = string.format(format_string, entry.display,
                            vim.fn.fnamemodify(entry.path, ":~")),
                        ordinal = entry.display .. " " .. entry.path
                    }
                end,
            }),
            sorter = require("telescope.config").values.generic_sorter({}),
            attach_mappings = function(prompt_bufnr, map)
                actions.select_default:replace(function()
                    local selection = action_state.get_selected_entry()
                    local search_dir = selection.value
                    actions.close(prompt_bufnr)
                    config.picker_func({
                        prompt_title = config.prompt_prefix .. vim.fn.fnamemodify(search_dir, ":~"),
                        cwd = search_dir, -- This correctly scopes the search.
                        default_text = initial_query,
                        attach_mappings = function(inner_prompt_bufnr, inner_map)
                            -- V V V THIS IS THE ONLY PART THAT HAS BEEN MODIFIED V V V
                            actions.select_default:replace(function()
                                local file_selection = action_state.get_selected_entry()
                                actions.close(inner_prompt_bufnr)

                                -- Get the relative path from the selection.
                                -- `live_grep` provides `filename`, `find_files` provides `value`.
                                local relative_path = file_selection.filename or file_selection.value

                                -- Construct the full absolute path by joining the search directory
                                -- with the file's relative path.
                                local full_path = search_dir .. "/" .. relative_path

                                -- Open the buffer using the full path, ensuring special characters are escaped.
                                vim.cmd.edit(vim.fn.fnameescape(full_path))

                                -- If it was a grep result, go to the correct line number.
                                if file_selection.lnum then
                                    vim.api.nvim_win_set_cursor(0, { file_selection.lnum, 0 })
                                end
                            end)
                            -- ^ ^ ^ END OF MODIFIED SECTION ^ ^ ^

                            inner_map("i", "<leader>cd", function()
                                local picker = action_state.get_current_picker(inner_prompt_bufnr)
                                local current_query = picker:_get_prompt()
                                actions.close(inner_prompt_bufnr)
                                workflow_func({ query = current_query })
                            end)
                            return true
                        end,
                    })
                end)
                return true
            end,
        }):find()
    end
    return workflow_func
end

-- Create the specific workflow functions using the generator
local scoped_file_finder = create_scoped_picker_workflow({
    picker_func = builtin.find_files,
    prompt_prefix = "Find Files in: ",
})
local scoped_live_grepper = create_scoped_picker_workflow({
    picker_func = builtin.live_grep,
    prompt_prefix = "Live Grep in: ",
})

-- 4. FINAL KEYMAPS FOR CUSTOM FUNCTIONS
vim.keymap.set("n", "<leader>FF", scoped_file_finder, { desc = "Telescope: Scoped find files" })
vim.keymap.set("n", "<leader>FG", scoped_live_grepper, { desc = "Telescope: Scoped live grep" })
vim.keymap.set("n", "<leader>cd", project_hotlist_picker, { desc = "Project: Change Directory (Hotlist)" })

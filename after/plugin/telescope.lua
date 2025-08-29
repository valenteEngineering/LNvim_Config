-- File for setting all re-maps for the telescope plugin
local builtin = require('telescope.builtin')
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local nvim_tree_api = require("nvim-tree.api")

-- Keymaps for standard Telescope functions
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = 'Telescope keymaps' })


-- LENTIL IMPLEMENTAION OF PROJECT SIDESCOPE FOR DIR BASE FF AND FG
-- Define your project's important directories.
local project_hotlist = {
    { display = "YOCTO_BUILD_DIR", path = "/home/alexvalente/CompulabQtYocto/build-imx8mm-lpddr4-evk/tmp/deploy/images/imx8mm-lpddr4-evk" },
    { display = "YOCTO_KERNEL_DIR",    path = "/home/alexvalente/CompulabQtYocto/build-imx8mm-lpddr4-evk/tmp/work-shared/imx8mm-lpddr4-evk/kernel-source" },
    { display = "ATTOLLO_META_LAYER",  path = "/home/alexvalente/CompulabQtYocto/sources/meta-attolloVasRf" },
    { display = "YOCTO_MEDIA_DRIVERS",        path = "/home/alexvalente/CompulabQtYocto/build-imx8mm-lpddr4-evk/tmp/work-shared/imx8mm-lpddr4-evk/kernel-source/drivers/media" },
}

-- The standard hotlist picker function (for changing directory)
local function project_hotlist_picker()
    -- ... (this function is unchanged and remains as it was)
    local max_width = 0
    for _, item in ipairs(project_hotlist) do if #item.display > max_width then max_width = #item.display end end
    max_width = max_width + 2
    require("telescope.pickers").new({}, {
        prompt_title = "Project Hotlist",
        finder = require("telescope.finders").new_table({
            results = project_hotlist,
            entry_maker = function(entry)
                local format_string = "%-" .. tostring(max_width) .. "s | %s"
                return { value = entry.path, display = string.format(format_string, entry.display, vim.fn.fnamemodify(entry.path, ":~")), ordinal = entry.display .. " " .. entry.path }
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


-- This function takes a config and returns a new function that runs our workflow
local function create_scoped_picker_workflow(config)
    local workflow_func = nil -- Forward declare for recursion

    workflow_func = function(opts)
        opts = opts or {}
        local initial_query = opts.query or ""

        -- Stage 1: Pick the search directory
        require("telescope.pickers").new({}, {
            prompt_title = "Select Search Directory",
            finder = require("telescope.finders").new_table({ results = project_hotlist, entry_maker = function(entry)
                local max_width = 0
                for _, item in ipairs(project_hotlist) do if #item.display > max_width then max_width = #item.display end end
                max_width = max_width + 2
                local format_string = "%-" .. tostring(max_width) .. "s | %s"
                return { value = entry.path, display = string.format(format_string, entry.display, vim.fn.fnamemodify(entry.path, ":~")), ordinal = entry.display .. " " .. entry.path }
            end }),
            sorter = require("telescope.config").values.generic_sorter({}),
            attach_mappings = function(prompt_bufnr, map)
                actions.select_default:replace(function()
                    local selection = action_state.get_selected_entry()
                    local search_dir = selection.value
                    actions.close(prompt_bufnr)

                    -- Stage 2: Open the specified picker (find_files or live_grep)
                    config.picker_func({
                        prompt_title = config.prompt_prefix .. vim.fn.fnamemodify(search_dir, ":~"),
                        cwd = search_dir,
                        default_text = initial_query,
                        attach_mappings = function(inner_prompt_bufnr, inner_map)
                            -- Final action on <CR>
                            actions.select_default:replace(function()
                                local file_selection = action_state.get_selected_entry()
                                actions.close(inner_prompt_bufnr)

                                -- This logic works for both find_files and live_grep results
                                local file_path = file_selection.filename or file_selection.value

                                vim.cmd.cd(search_dir)
                                nvim_tree_api.tree.change_root(search_dir)
                                vim.cmd.edit(file_path)

                                -- If it's a grep result, go to the correct line
                                if file_selection.lnum then
                                    vim.api.nvim_win_set_cursor(0, { file_selection.lnum, 0 })
                                end
                            end)

                            -- Keymap to change scope
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

-- Create the specific workflow functions using our generator
local scoped_file_finder = create_scoped_picker_workflow({
    picker_func = builtin.find_files,
    prompt_prefix = "Find Files in: "
})

local scoped_live_grepper = create_scoped_picker_workflow({
    picker_func = builtin.live_grep,
    prompt_prefix = "Live Grep in: "
})

---- Set all the final keymaps
vim.keymap.set('n', '<leader>FF', scoped_file_finder, { desc = 'Telescope scoped find files' })
vim.keymap.set('n', '<leader>FG', scoped_live_grepper, { desc = 'Telescope scoped live grep' })
vim.keymap.set('n', '<leader>cd', project_hotlist_picker, { desc = 'Project: Hotlist' })

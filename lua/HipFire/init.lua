-- lua/HipFire/init.lua
local state = require("HipFire.state")
local hotlist = require("HipFire.hotlist")
local builtin = require("telescope.builtin")
local action_state = require("telescope.actions.state")

local M = {}

function M.setup()
    hotlist.load()
end

function M.find_files()
    local current_state = state.get_state()
    
    if #current_state.hotlist == 0 then
        print("HipFire: Hotlist is empty. Add directories from nvim-tree with <leader>A.")
        return
    end

    local search_dir = current_state.hotlist[current_state.active_idx].path
    
    builtin.find_files({
        -- This initial title will be immediately replaced.
        prompt_title = " ",
        cwd = search_dir,
        layout_strategy = 'horizontal',
        layout_config = {
            width = 0.5,
        },

        attach_mappings = function(prompt_bufnr, map)
            local picker = action_state.get_current_picker(prompt_bufnr)
            -- We need the ID of the main border window to get geometry
            local border_winid = picker.border_winid
            -- We need the ID of the prompt window to change its title
            local prompt_winid = picker.prompt_winid

            if border_winid and prompt_winid then
                -- Get geometry from the main border window
                local width = vim.api.nvim_win_get_width(border_winid)
                local height = vim.api.nvim_win_get_height(border_winid)
                local position = vim.api.nvim_win_get_position(border_winid)

                -- Format the geometry string
                local geometry_string = "test"
--                local geometry_string = string.format(
--                    "X:%d Y:%d W:%d H:%d",
--                    position.col, position.row, width, height
--                )

                -- [[ THE DEFINITIVE FIX ]]
                -- Use the Neovim API to change the 'title' option of the prompt window.
                vim.api.nvim_win_set_option(prompt_winid, 'title', geometry_string)
            end
            
            return true
        end,
    })
end

return M

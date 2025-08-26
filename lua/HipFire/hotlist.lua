-- lua/HipFire/hotlist.lua
local state = require("HipFire.state")
local ui = require("HipFire.ui")

local M = {}

local data_file = vim.fn.stdpath("data") .. "/sidescope.json"

function M.save()
    local hotlist_data = state.get_state().hotlist
    local json_data = vim.fn.json_encode(hotlist_data)
    vim.fn.writefile({json_data}, data_file)
end

function M.load()
    if vim.fn.filereadable(data_file) == 1 then
        local file_content = vim.fn.readfile(data_file)
        if #file_content > 0 then
            state.get_state().hotlist = vim.fn.json_decode(file_content[1])
        end
    else
        state.get_state().hotlist = {}
    end
end

function M.add(path)
    local state_table = state.get_state()
    for _, item in ipairs(state_table.hotlist) do
        if item.path == path then
            print("SideScope: Already in hotlist.")
            return
        end
    end
    
    local display_name = vim.fn.fnamemodify(path, ":t")
    table.insert(state_table.hotlist, { display = display_name, path = path })
    print("SideScope: Added '" .. display_name .. "' to hotlist.")
    
    M.save()
    if state.is_open() then ui.update() end
end

function M.remove(path)
    local state_table = state.get_state()
    local index_to_remove = nil
    for i, item in ipairs(state_table.hotlist) do
        if item.path == path then index_to_remove = i; break end
    end
    
    if index_to_remove then
        local removed_item = table.remove(state_table.hotlist, index_to_remove)
        print("SideScope: Removed '" .. removed_item.display .. "' from hotlist.")
        M.save()
        if state.is_open() then
            if state_table.active_idx > #state_table.hotlist and #state_table.hotlist > 0 then
                state.prev_scope()
            end
            ui.update()
        end
    else
        print("SideScope: Not in hotlist.")
    end
end

return M

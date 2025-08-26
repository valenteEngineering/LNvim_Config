-- lua/HipFire/ui.lua
local state_manager = require("HipFire.state")

local M = {}

function M.update()
    local state = state_manager.get_state()
    if not state.buf_handle or not vim.api.nvim_buf_is_valid(state.buf_handle) then return end

    local display_lines = {}
    for i, item in ipairs(state.hotlist) do
        local prefix = (i == state.active_idx) and " -> " or "    "
        table.insert(display_lines, prefix .. item.display)
    end
    vim.api.nvim_buf_set_lines(state.buf_handle, 0, -1, false, display_lines)
end

function M.create()
    local screen_w = vim.o.columns
    local screen_h = vim.o.lines

    local width_ratio = 0.5
    local total_width = math.floor(screen_w * width_ratio)
    local total_height = math.floor(screen_h * height_ratio)

    local scope_win_width = math.floor(total_width * 0.3)
    local telescope_win_width = total_width - scope_win_width

    local start_y = math.floor((screen_h - total_height) / 2)
    local start_x = math.floor((screen_w - total_width) / 2)

    local buf_handle = vim.api.nvim_create_buf(false, true)
    local scope_win_handle = vim.api.nvim_open_win(buf_handle, true, {
        relative = "editor",
        width = scope_win_width,
        height = total_height,
        row = start_y,
        col = start_x,
        style = "minimal",
        border = "rounded",
        title = " Scope ",
        title_pos = "center",
    })

    state_manager.set_handles(scope_win_handle, buf_handle)
    M.update()

    return {
        width = telescope_win_width,
        height = total_height,
        row = start_y,
        col = start_x + scope_win_width,
    }
end

function M.destroy()
    local state = state_manager.get_state()
    if state.win_handle and vim.api.nvim_win_is_valid(state.win_handle) then
        vim.api.nvim_win_close(state.win_handle, true)
    end
    state_manager.clear_handles()
end

return M

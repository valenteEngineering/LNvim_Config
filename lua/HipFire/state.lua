-- lua/HipFire/state.lua
local M = {}

M.state = {
    win_handle = nil,
    buf_handle = nil,
    is_relaunching = false,
    hotlist = {}, -- Will be filled by hotlist.load()
    active_idx = 1,
}

-- Public functions to safely get and modify the state
M.get_state = function() return M.state end
M.is_open = function() return M.state.win_handle ~= nil end
M.set_handles = function(win, buf) M.state.win_handle, M.state.buf_handle = win, buf end
M.clear_handles = function() M.state.win_handle, M.state.buf_handle = nil, nil end

M.set_relaunching = function(val) M.state.is_relaunching = val end

M.next_scope = function()
    M.state.active_idx = M.state.active_idx + 1
    if M.state.active_idx > #M.state.hotlist then
        M.state.active_idx = 1 -- Wrap around
    end
end

M.prev_scope = function()
    M.state.active_idx = M.state.active_idx - 1
    if M.state.active_idx < 1 then
        M.state.active_idx = #M.state.hotlist -- Wrap around
    end
end

return M

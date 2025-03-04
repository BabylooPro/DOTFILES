-- MODULE TO NORMALIZE NEOTREE WIDTH
local M = {}

function M.resize()
    -- GET CURRENT TABPAGE
    local tn = vim.api.nvim_get_current_tabpage()
    local tree_win_handle = nil

    -- FIND NEOTREE WINDOW
    for _, window_handle in ipairs(vim.api.nvim_tabpage_list_wins(tn)) do
        local buffer_handle = vim.api.nvim_win_get_buf(window_handle)
        local buf_name = vim.fn.bufname(buffer_handle)
        if string.match(buf_name, 'neo%-tree') then
            tree_win_handle = window_handle
            break
        end
    end

    -- IF NO NEOTREE WINDOW FOUND, EXIT
    if tree_win_handle == nil then
        return
    end

    -- GET CONFIGURED WIDTH (DEFAULT 40)
    local configured_width = 40

    -- IF CURRENT WIDTH IS DIFFERENT, RESET IT
    if vim.api.nvim_win_get_width(tree_win_handle) ~= configured_width then
        vim.api.nvim_win_set_width(tree_win_handle, configured_width)
    end
end

return M

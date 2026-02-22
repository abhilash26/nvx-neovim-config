-- ======================================================================
-- Core utilities and helper functions
-- ======================================================================

local M = {}

-- Create augroup helper
function M.augroup(name)
    return vim.api.nvim_create_augroup('nvx' .. name, { clear = true })
end

-- Notification helpers
function M.notify_info(log)
    vim.notify(log, vim.log.levels.INFO)
end

function M.notify_error(log)
    vim.notify(log, vim.log.levels.ERROR)
end

-- Keymap helper
function M.map(mode, lhs, rhs, opts)
    opts = opts or {}
    vim.keymap.set(mode, lhs, rhs, opts)
end

return M

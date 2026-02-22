-- ======================================================================
--  Minimal Neovim config using ONLY mini.deps
--  Performance optimizations:
--  - Lazy-loading: Blink.cmp, Conform, Colorizer, LSP load on-demand
--  - Treesitter: Disabled for large files (>100KB or >5000 lines)
--  - Blink.cmp: Prebuilt Rust binaries (auto-download), optimized settings
--  - LSP: Semantic tokens disabled, document highlight on CursorHold only
--  - Buffer completion: Limited to 5 items, min 2 chars
--  - Documentation: Fast 200ms delay with rounded borders
-- ======================================================================

-- ---[ Bootstrap mini.nvim ]--------------------------------------------
local data_path = vim.fn.stdpath('data')
local mini_path = data_path .. '/site/pack/deps/start/mini.nvim'

if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing mini.nvim..." | redraw')
    vim.fn.system({
        'git', 'clone', '--filter=blob:none',
        'https://github.com/nvim-mini/mini.nvim',
        mini_path,
    })
    vim.cmd('packadd mini.nvim | helptags ALL')
    vim.cmd('echo "Installed mini.nvim." | redraw')
end

-- ---[ Setup mini.deps ]------------------------------------------------
require('mini.deps').setup({
    path = { package = data_path .. '/site' },
    silent = true,
})

-- Load core utilities
local core = require('nvx.core')

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local api = vim.api

-- Manage mini.nvim itself
add('nvim-mini/mini.nvim')

-- ======================================================================
-- = Load Plugin Modules                                                =
-- ======================================================================

-- UI: Colorscheme, File Explorer, Icons
require('nvx.plugins.ui')(add, now, core)

-- Treesitter: Syntax highlighting
require('nvx.plugins.treesitter')(add, later)

-- Completion: Blink.cmp
require('nvx.plugins.completion')(add, now, later, core)

-- Formatting: Conform
require('nvx.plugins.formatting')(add, now, later, core)

-- Colorizer: Color preview
require('nvx.plugins.colorizer')(add, later, core)

-- Editing: Surround and Pairs
require('nvx.plugins.editing')(add, later)

-- FZF: Fuzzy finder
require('nvx.plugins.fzf')(add, later, core)

-- LSP: Language servers
require('nvx.plugins.lsp')(add, later, core)

-- ======================================================================
-- = Extra: maintenance helpers                                         =
-- ======================================================================

api.nvim_create_user_command('DepsUpdate', function()
    MiniDeps.update()
    vim.notify('Plugins updated via mini.deps', vim.log.levels.INFO)
end, { desc = 'Update all plugins managed by mini.deps' })

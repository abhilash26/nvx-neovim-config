-- ======================================================================
-- FZF: Fuzzy finder for files, grep, git, etc.
-- ======================================================================

return function(add, later, core)
    local map = core.map

    later(function()
        add({
            source = 'ibhagwan/fzf-lua',
            depends = { 'echasnovski/mini.icons' },
        })

        -- Override vim.ui.select to use fzf-lua
        vim.ui.select = function(...)
            -- Load fzf-lua before using vim.ui.select
            require('fzf-lua')
            return vim.ui.select(...)
        end

        -- Lazy-load fzf-lua on first keymap use
        local fzf_loaded = false
        local function setup_fzf()
            if fzf_loaded then return end
            fzf_loaded = true

            local fzf = require('fzf-lua')
            fzf.register_ui_select()
            fzf.setup({
                profile = 'fzf-native',
                fzf_opts = {
                    ['--history'] = vim.fn.stdpath('cache') .. '/nvim/fzf-lua-history',
                },
                grep = {
                    rg_opts = '--sort-files --hidden --column --line-number --no-heading '
                        .. "--color=always --smart-case -g '!{.git,node_modules,vendor,.next}/*'",
                },
                files = {
                    fd_opts = '--type f --exclude node_modules --exclude .git --exclude vendor --exclude .next',
                },
            })
        end

        -- Keymaps with lazy loading
        local function fzf_cmd(cmd)
            return function()
                setup_fzf()
                vim.cmd(cmd)
            end
        end

        -- File finding
        map('n', '<c-p>', fzf_cmd('FzfLua files cwd=%:p:h'), { desc = 'Find files (cwd)' })
        map('n', '<leader>ff', fzf_cmd('FzfLua files cwd=%:p:h'), { desc = 'Find files (cwd)' })
        map('n', '<leader>fc', fzf_cmd('FzfLua files cwd=~/.config/nvim'), { desc = 'Find nvim config' })
        map('n', '<leader>fo', fzf_cmd('FzfLua oldfiles'), { desc = 'Recent files' })
        map('n', '<leader>fb', fzf_cmd('FzfLua buffers'), { desc = 'Find recent buffers' })

        -- Grep/Search
        map('n', '<leader>fg', fzf_cmd('FzfLua grep cwd=%:p:h'), { desc = 'Find in files (cwd)' })

        -- Help/Documentation
        map('n', '<leader>fh', fzf_cmd('FzfLua help_tags'), { desc = 'Help pages' })
        map('n', '<leader>fm', fzf_cmd('FzfLua man_pages'), { desc = 'Man pages' })
        map('n', '<leader>fk', fzf_cmd('FzfLua keymaps'), { desc = 'Find keymaps' })

        -- Vim/Neovim
        map('n', '<leader>ft', fzf_cmd('FzfLua colorschemes'), { desc = 'Find colorschemes' })
        map('n', '<leader>fq', fzf_cmd('FzfLua quickfix'), { desc = 'Find quickfix' })
        map('n', '<leader>:', fzf_cmd('FzfLua command_history'), { desc = 'Find command history' })

        -- Git
        map('n', '<leader>gs', fzf_cmd('FzfLua git_status'), { desc = 'Find git status' })
        map('n', '<leader>gc', fzf_cmd('FzfLua git_commits'), { desc = 'Find git commits' })
        map('n', '<leader>gb', fzf_cmd('FzfLua git_branches'), { desc = 'Find git branches' })
    end)
end

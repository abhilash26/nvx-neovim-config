-- ======================================================================
-- Treesitter: Syntax highlighting and parsing
-- ======================================================================

return function(add, later)
    later(function()
        add({
            source = 'nvim-treesitter/nvim-treesitter',
            checkout = 'master',
            monitor = 'main',
            hooks = {
                post_checkout = function() vim.cmd('TSUpdate') end,
            },
        })

        require('nvim-treesitter.install').prefer_git = true
        require('nvim-treesitter.configs').setup({
            ensure_installed = {
                'bash', 'dockerfile', 'yaml', 'toml', 'json', 'jsonc',
                'html', 'css', 'scss', 'javascript', 'typescript', 'tsx',
                'c', 'cpp', 'rust', 'go',
                'lua', 'python', 'php',
                'markdown', 'markdown_inline', 'vim', 'vimdoc',
                'sql', 'diff', 'git_config', 'git_rebase', 'gitcommit', 'gitignore', 'regex',
            },
            highlight = {
                enable = true,
                disable = function(_, buf)
                    local api = vim.api
                    -- Disable for large files
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.loop.fs_stat, api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end

                    -- Disable for files with many lines
                    local line_count = api.nvim_buf_line_count(buf)
                    if line_count > 5000 then
                        return true
                    end

                    return false
                end,
                additional_vim_regex_highlighting = false,
            },
            indent = {
                enable = true,
                disable = { 'python', 'yaml' },
            },
            incremental_selection = { enable = false },
            textobjects = { enable = false },
        })
    end)
end

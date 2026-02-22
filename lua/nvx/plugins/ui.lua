-- ======================================================================
-- UI Plugins: Colorscheme, File Explorer, Icons
-- ======================================================================

return function(add, now, core)
    local map = core.map

    now(function()
        -- Colorscheme
        -- add('abhilash26/mapledark.nvim')
        add('vague-theme/vague.nvim')
        vim.o.termguicolors = true
        vim.cmd.colorscheme('vague')

        -- Oil (file explorer)
        add({
            source = 'stevearc/oil.nvim',
            depends = { 'echasnovski/mini.icons' },
        })

        require('mini.icons').setup()
        require('oil').setup({
            default_file_explorer = true,
            columns = { 'icon' },
            delete_to_trash = true,
            skip_confirm_for_simple_edits = true,
            view_options = { show_hidden = true },
            float = { max_width = 75, max_height = 25 },
            win_options = { number = false, signcolumn = 'no' },
            keymaps = { ['<C-h>'] = false },
        })

        map('n', '-', '<cmd>Oil<cr>', { desc = 'Open parent directory' })

        -- Rainbow Delimiters
        add('HiPhish/rainbow-delimiters.nvim')
    end)
end

-- ======================================================================
-- Editing: Mini.surround and Mini.pairs
-- ======================================================================

return function(add, later)
    later(function()
        -- Mini Surround
        add({ source = 'echasnovski/mini.surround', checkout = 'stable' })
        require('mini.surround').setup({
            mappings = { add = 'ys', delete = 'ds', replace = 'cs' },
        })

        -- Mini Pairs
        add({ source = 'echasnovski/mini.pairs', checkout = 'stable' })
        require('mini.pairs').setup({
            modes = { insert = true, command = true, terminal = false },
            skip_next = [=[[%w%%%'%[%'%.%`%$]]=],
            skip_ts = { 'string' },
            skip_unbalanced = true,
            markdown = true,
        })

        -- Mini Comments
        add({ source = 'nvim-mini/mini.comment', checkout = 'stable' })
        require('mini.comment').setup()
    end)
end

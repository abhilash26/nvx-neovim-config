-- ======================================================================
-- Colorizer: Color preview for CSS/HTML/etc
-- ======================================================================

return function(add, later, core)
    local api = vim.api
    local augroup = core.augroup

    later(function()
        add('catgoose/nvim-colorizer.lua')

        local colorizer_fts = {
            'css', 'scss', 'html', 'php', 'sass', 'typescript',
            'javascript', 'svelte', 'vue', 'templ',
        }

        local colorizer_loaded = false
        api.nvim_create_autocmd('FileType', {
            pattern = colorizer_fts,
            group = augroup('colorizer_load'),
            callback = function()
                if colorizer_loaded then return end
                colorizer_loaded = true

                require('colorizer').setup({
                    filetypes = colorizer_fts,
                    user_default_options = {
                        RRGGBBAA = true,
                        rgb_fn = true,
                        hsl_fn = true,
                        css = true,
                        css_fn = true,
                        tailwind = true,
                        sass = { enable = true, parsers = { 'css' } },
                    },
                })
            end,
        })
    end)
end

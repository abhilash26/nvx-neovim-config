-- ======================================================================
-- Formatting: Conform.nvim
-- ======================================================================

return function(add, now, later, core)
    local api = vim.api
    local augroup = core.augroup

    later(function()
        add { source = "stevearc/conform.nvim" }

        local function setup_conform()
            local prettier = { "prettierd", "prettier", stop_after_first = true }
            local conform_opts = {
                bash = { "shfmt" },
                sh = { "shfmt" },
                zsh = { "shfmt" },
                go = { "goimports", "gofumpt" },
                lua = { "stylua" },
                php = { "php-cs-fixer" },
                python = { "isort", "black" },
                rust = { "rustfmt", lsp_format = "fallback" },
                sql = { "sql-formatter" },
            }

            local prettier_ft = {
                "css",
                "html",
                "javascript",
                "typescript",
                "javascriptreact",
                "json",
                "jsonc",
                "markdown",
                "scss",
                "svelte",
                "vue",
                "yaml",
            }

            for _, ft in ipairs(prettier_ft) do
                conform_opts[ft] = prettier
            end

            require("conform").setup {
                notify_on_error = false,
                formatters_by_ft = conform_opts,
                formatters = {
                    shfmt = { prepend_args = { "-i", "2", "-ci" } },
                    stylua = {
                        prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
                    },
                },
            }
        end

        local conform_loaded = false
        api.nvim_create_autocmd({ "BufEnter" }, {
            once = true,
            group = augroup "conform_load",
            callback = function()
                if conform_loaded then
                    return
                end
                conform_loaded = true
                now(setup_conform)
                core.map({ "n", "v" }, "<F3>", function()
                    require("conform").format {
                        async = false,
                        quiet = false,
                        lsp_format = "fallback",
                        timeout_ms = 500,
                    }
                end, { buffer = 0, desc = "[F]ormat buffer" })
            end,
        })
    end)
end

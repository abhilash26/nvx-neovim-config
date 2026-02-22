-- ======================================================================
-- LSP: Language Server Protocol configuration
-- ======================================================================

return function(add, later, core)
    local api = vim.api
    local augroup = core.augroup
    local map = core.map

    later(function()
        -- Mason (standalone, available immediately via :Mason command)
        add({ source = 'williamboman/mason.nvim' })
        require('mason').setup({
            ui = {
                border = 'rounded',
                icons = {
                    package_installed = '✓',
                    package_pending = '➜',
                    package_uninstalled = '✗',
                },
            },
        })

        -- LSP Config
        add({
            source = 'neovim/nvim-lspconfig',
            depends = {
                'williamboman/mason.nvim',
                'williamboman/mason-lspconfig.nvim',
                'saghen/blink.cmp',
            },
        })

        -- Lazy-load LSP setup on relevant events
        local lsp_loaded = false
        api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
            once = true,
            group = augroup('lsp_load'),
            callback = function()
                if lsp_loaded then return end
                lsp_loaded = true

                -- Performance: Disable semantic tokens for better performance
                for _, group in ipairs(vim.fn.getcompletion('@lsp', 'highlight')) do
                    api.nvim_set_hl(0, group, {})
                end

                -- Note: Diagnostics config is in plugin/diagnostics.lua

                -- LSP servers to install
                local servers = {
                    'bashls', 'clangd', 'cssls', 'css_variables', 'emmet_ls',
                    'gopls', 'html', 'htmx', 'intelephense', 'jsonls',
                    'lua_ls', 'marksman', 'pyright', 'svelte', 'tailwindcss',
                    'templ', 'ts_ls', 'vuels',
                }

                require('mason-lspconfig').setup({
                    ensure_installed = servers,
                    automatic_installation = true,
                })

                -- Get capabilities from blink.cmp
                local capabilities = require('blink.cmp').get_lsp_capabilities()

                -- LSP Keymaps (set on LspAttach)
                api.nvim_create_autocmd('LspAttach', {
                    group = augroup('lsp_attach'),
                    callback = function(event)
                        local lsp_map = function(keys, func, desc, mode)
                            mode = mode or 'n'
                            map(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                        end

                        -- Navigation
                        lsp_map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
                        lsp_map('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
                        lsp_map('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
                        lsp_map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                        lsp_map('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')

                        -- Symbols
                        lsp_map('<leader>ds', vim.lsp.buf.document_symbol, '[D]ocument [S]ymbols')
                        lsp_map('<leader>ws', vim.lsp.buf.workspace_symbol, '[W]orkspace [S]ymbols')

                        -- Actions
                        lsp_map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                        lsp_map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'v' })
                        lsp_map('K', vim.lsp.buf.hover, 'Hover Documentation')

                        -- Diagnostics
                        lsp_map('[d', vim.diagnostic.goto_prev, 'Previous [D]iagnostic')
                        lsp_map(']d', vim.diagnostic.goto_next, 'Next [D]iagnostic')
                        lsp_map('<leader>e', vim.diagnostic.open_float, 'Show [E]rror')
                        lsp_map('<leader>q', vim.diagnostic.setloclist, 'Diagnostic [Q]uickfix')

                        -- Performance: Only enable document highlight if supported
                        local client = vim.lsp.get_client_by_id(event.data.client_id)
                        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                            local highlight_augroup = augroup('lsp_highlight')
                            api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                                buffer = event.buf,
                                group = highlight_augroup,
                                callback = vim.lsp.buf.document_highlight,
                            })
                            api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                                buffer = event.buf,
                                group = highlight_augroup,
                                callback = vim.lsp.buf.clear_references,
                            })

                            -- Clean up on detach
                            api.nvim_create_autocmd('LspDetach', {
                                group = augroup('lsp_detach'),
                                callback = function(event2)
                                    vim.lsp.buf.clear_references()
                                    api.nvim_clear_autocmds({ group = highlight_augroup, buffer = event2.buf })
                                end,
                            })
                        end

                        -- Performance: Disable semantic tokens for specific clients
                        if client and client.name == 'ts_ls' then
                            client.server_capabilities.semanticTokensProvider = nil
                        end
                    end,
                })

                -- Configure and enable LSP servers
                for _, server in ipairs(servers) do
                    local config = { capabilities = capabilities }

                    -- Server-specific configurations
                    if server == 'lua_ls' then
                        config.settings = {
                            Lua = {
                                runtime = { version = 'LuaJIT' },
                                workspace = {
                                    checkThirdParty = false,
                                    library = { vim.env.VIMRUNTIME },
                                },
                                telemetry = { enable = false },
                            },
                        }
                    elseif server == 'ts_ls' then
                        config.settings = {
                            typescript = {
                                inlayHints = {
                                    includeInlayParameterNameHints = 'all',
                                    includeInlayFunctionParameterTypeHints = true,
                                },
                            },
                        }
                    end

                    vim.lsp.config[server] = config
                end

                -- Enable all LSP servers
                vim.lsp.enable(servers)
            end,
        })
    end)
end

-- ======================================================================
-- Completion: Blink.cmp with prebuilt binaries + Supermaven integration
-- ======================================================================

return function(add, now, later, core)
    local api = vim.api
    local augroup = core.augroup

    local notify_info = core.notify_info
    local notify_error = core.notify_error

    later(function()
        ----------------------------------------------------------------------
        -- Supermaven
        ----------------------------------------------------------------------
        add { source = "supermaven-inc/supermaven-nvim", checkout = "main" }

        require("supermaven-nvim").setup {
            keymaps = {
                accept_suggestion = "<Right>",
            },
            log_level = "warn",
            ignore_filetypes = {
                -- non-code
                "markdown",
                "text",
                "org",
                "gitcommit",
                "csv",

                -- plugin UIs
                "neo-tree",
                "oil",
                "lazy",
                "mason",
                "trouble",
                "spectre_panel",
                "noice",
                "alpha",
                "dashboard",
                "snacks_dashboard",

                -- git and diff
                "git",
                "gitrebase",

                -- misc tools
                "checkhealth",
                "query",
                "tsplayground",
                "toggleterm",
                "qf",
            },

            condition = function()
                local ft = vim.bo.filetype
                local excluded = { "Oil", "help", "mason", "Fzflua" }
                return vim.tbl_contains(excluded, ft)
            end,
        }

        ----------------------------------------------------------------------
        -- Blink binary download
        ----------------------------------------------------------------------
        local function download_blink_binary(params)
            local target_dir = params.path .. "/target/release"
            local binary_path = target_dir .. "/libblink_cmp_fuzzy.so"

            if vim.fn.filereadable(binary_path) == 1 then
                notify_info "blink.cmp binary already exists"
                return
            end

            vim.fn.mkdir(target_dir, "p")
            notify_info "Downloading blink.cmp prebuilt binary..."

            local url =
            "https://github.com/saghen/blink.cmp/releases/download/v1.7.0/x86_64-unknown-linux-gnu.so"

            vim.fn.jobstart({ "curl", "-L", url, "-o", binary_path }, {
                on_exit = function(_, code)
                    if code == 0 then
                        notify_info "✓ blink.cmp binary downloaded successfully"
                    else
                        notify_error "✗ Failed to download blink.cmp binary"
                    end
                end,
            })
        end

        ----------------------------------------------------------------------
        -- Blink plugin
        ----------------------------------------------------------------------
        add {
            source = "saghen/blink.cmp",
            depends = {
                "rafamadriz/friendly-snippets",
            },
            checkout = "v1.7.0",
            hooks = {
                post_install = download_blink_binary,
                post_checkout = download_blink_binary,
            },
        }

        ----------------------------------------------------------------------
        -- Blink setup (lazy-loaded)
        ----------------------------------------------------------------------
        local function setup_blink()
            require("blink.cmp").setup {
                keymap = {
                    preset = "default",
                    ["<Tab>"] = { "select_next", "fallback" },

                    ["<S-Tab>"] = { "select_prev", "fallback" },
                    ["<CR>"] = { "accept", "fallback" },
                },

                appearance = {
                    nerd_font_variant = "mono",
                },

                completion = {
                    accept = { auto_brackets = { enabled = true } },
                    menu = {
                        draw = {
                            columns = {
                                { "label",     "label_description", gap = 3 },
                                { "kind_icon", "kind",              gap = 1 },
                            },
                        },
                    },
                    documentation = {

                        auto_show = true,
                        auto_show_delay_ms = 200,
                        window = { border = "rounded" },
                    },
                },

                ------------------------------------------------------------------
                -- BLINK SOURCES (WITH SUPERMAVEN)
                ------------------------------------------------------------------
                sources = {

                    default = {
                        "lsp",
                        "path",
                        "snippets",
                        "buffer",
                    },

                    providers = {
                        -- buffer
                        buffer = {
                            min_keyword_length = 2,
                            max_items = 5,
                        },

                        -- path
                        path = {
                            opts = {
                                trailing_slash = true,
                                label_trailing_slash = true,
                            },
                        },
                    },
                },

                fuzzy = {
                    use_proximity = true,
                    frecency = { enabled = true },
                    prebuilt_binaries = {
                        download = true,
                        force_version = nil,
                        force_system_triple = nil,
                    },
                },
            }
        end

        ----------------------------------------------------------------------
        -- Lazy loading triggers
        ----------------------------------------------------------------------
        local blink_loaded = false

        api.nvim_create_autocmd({ "LspAttach", "InsertEnter" }, {
            once = true,
            group = augroup "blink_load",
            callback = function()
                if blink_loaded then
                    return
                end
                blink_loaded = true
                now(setup_blink)
            end,
        })
    end)
end

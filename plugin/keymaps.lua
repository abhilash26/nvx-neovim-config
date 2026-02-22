local keymaps = {

    -- ========== Window Navigation ==========
    { mode = "n",                    lhs = "<C-h>",      rhs = "<C-w>h",                     desc = "Go to left window" },
    { mode = "n",                    lhs = "<C-j>",      rhs = "<C-w>j",                     desc = "Go to lower window" },
    { mode = "n",                    lhs = "<C-k>",      rhs = "<C-w>k",                     desc = "Go to upper window" },
    { mode = "n",                    lhs = "<C-l>",      rhs = "<C-w>l",                     desc = "Go to right window" },

    -- ========== Buffer Navigation ==========
    { mode = "n",                    lhs = "<S-l>",      rhs = "<cmd>bnext<CR>",             desc = "Next buffer" },
    { mode = "n",                    lhs = "<S-h>",      rhs = "<cmd>bprevious<CR>",         desc = "Previous buffer" },
    { mode = "n",                    lhs = "<BS>",       rhs = "<cmd>b#<CR>",                desc = "Last buffer" },
    { mode = "n",                    lhs = "<leader>fn", rhs = "<cmd>ene | startinsert<CR>", desc = "New buffer" },

    -- ========== Better Indenting ==========
    { mode = "v",                    lhs = "<",          rhs = "<gv",                        desc = "Indent left" },
    { mode = "v",                    lhs = ">",          rhs = ">gv",                        desc = "Indent right" },

    -- ========== Paging (at center) ==========
    { mode = "n",                    lhs = "<C-d>",      rhs = "<C-d>zz",                    desc = "Page down center" },
    { mode = "n",                    lhs = "<C-u>",      rhs = "<C-u>zz",                    desc = "Page up center" },

    -- ========== Smart Clipboard ==========
    { mode = "v",                    lhs = "p",          rhs = '"_dP',                       desc = "Paste (no ovr)" },
    { mode = "x",                    lhs = "<leader>p",  rhs = [["_dP]],                     desc = "Paste (no yank)" },
    { mode = { "n", "v" },           lhs = "<leader>d",  rhs = [["_d]],                      desc = "Delete (no yank)" },
    { mode = { "n", "v" },           lhs = "<leader>y",  rhs = [["+y]],                      desc = "Copy to clipboard" },

    -- ========== Move Lines ==========
    { mode = "v",                    lhs = "<S-j>",      rhs = ":m '>+1<CR>gv=gv",           desc = "Move line down" },
    { mode = "v",                    lhs = "<S-k>",      rhs = ":m '<-2<CR>gv=gv",           desc = "Move line up" },

    -- ========== File Saving ==========
    { mode = { "n", "i", "v", "x" }, lhs = "<C-s>",      rhs = "<cmd>w<CR><Esc>",            desc = "Save file" },

    -- ========== File Cleanup ==========
    {
        mode = "n",
        lhs = "<leader>sf",
        rhs = [[<cmd>silent! %s/\r//g | silent! %s/\s\+$//g | silent! %retab<CR>]],
        desc = "Remove ^M and trailing spaces"
    },

}

-- Apply mappings
for _, km in ipairs(keymaps) do
    vim.keymap.set(km.mode, km.lhs, km.rhs, {
        desc = km.desc,
        silent = true,
        noremap = true,
        expr = km.expr or false,
    })
end

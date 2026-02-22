local opt = vim.opt
local cache = vim.fn.stdpath("cache")

-- ====================================================================
-- FILES & BACKUP
opt.backup = false
opt.swapfile = false
opt.shadafile = cache .. "/nvim/shada/main.shada"
opt.undodir = cache .. "/nvim/undo"
opt.undofile = true

-- EDITING
opt.autoindent = true
opt.backspace = { "indent", "eol", "start" }
opt.breakindent = true
opt.expandtab = true
opt.foldlevel = 99
opt.shiftwidth = 2
opt.smartindent = true
opt.softtabstop = 2
opt.tabstop = 2
opt.wrap = false

-- SEARCH
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep --no-heading --smart-case"
opt.hlsearch = false
opt.ignorecase = true
opt.inccommand = "split"
opt.incsearch = true
opt.smartcase = true

-- UI & APPEARANCE
opt.colorcolumn = "80"
opt.conceallevel = 0
opt.concealcursor = ""
opt.cursorline = true
opt.cursorlineopt = "number"
opt.fillchars = { eob = " " }
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.matchtime = 2
opt.number = true
opt.relativenumber = false
opt.scrolloff = 10
opt.showmatch = true
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.termguicolors = true
opt.background = "dark"

-- SPLITS
opt.splitbelow = true
opt.splitright = true

-- PERFORMANCE
opt.ambiwidth = "single"
opt.autowrite = false
opt.emoji = false
opt.redrawtime = 1500
opt.smoothscroll = true
opt.synmaxcol = 240
opt.timeoutlen = 300
opt.ttyfast = true
opt.updatetime = 250

-- BEHAVIOR
opt.autochdir = false
opt.errorbells = false
opt.iskeyword:append("-")
opt.mouse = "a"
opt.path:append("**")
opt.selection = "inclusive"
opt.wildignorecase = true
opt.wildmenu = true
opt.wildmode = "longest:full,full"

-- DIFF
opt.diffopt:append("vertical")
opt.diffopt:append("algorithm:patience")
opt.diffopt:append("linematch:60")

-- FOLDING
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 99

-- STATUSLINE
opt.statusline = " 󰋑 %<%t %h%w%m%r %=  %f %= %y 󰋑 "

-- COMPLETION & MENU UI
opt.completeopt = "menu,menuone,noselect"
opt.pumblend = 10
opt.pumheight = 10
opt.winblend = 10
opt.shortmess:append("c")

if vim.fn.has("nvim-0.11") == 1 then
    opt.completeopt:append("fuzzy")
end

-- CLIPBOARD (DEFERRED)
vim.defer_fn(function()
    opt.clipboard:append("unnamedplus")
end, 100)

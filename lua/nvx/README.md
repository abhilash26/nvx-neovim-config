# NVX Plugin Configuration

Modular Neovim configuration using mini.deps plugin manager.

## Directory Structure

```
nvx/
├── core/
│   └── init.lua              # Core utilities (augroup, map, notify helpers)
├── plugins/
│   ├── ui.lua                # Colorscheme, Oil file explorer, Icons
│   ├── treesitter.lua        # Syntax highlighting with performance opts
│   ├── completion.lua        # Blink.cmp with prebuilt binaries
│   ├── formatting.lua        # Conform formatter
│   ├── colorizer.lua         # Color preview for CSS/HTML
│   ├── editing.lua           # Mini.surround and Mini.pairs
│   └── lsp.lua               # LSP servers and keymaps
└── plugins.lua               # Main entry point, loads all modules
```

## Module Categories

### Core (`core/init.lua`)
Shared utilities used across all plugin modules:
- `augroup(name)` - Create autocommand groups
- `map(mode, lhs, rhs, opts)` - Keymap helper
- `notify_info(msg)` - Info notifications
- `notify_error(msg)` - Error notifications

### UI (`plugins/ui.lua`)
- **Colorscheme**: mapledark.nvim
- **File Explorer**: oil.nvim with mini.icons
- **Delimiters**: rainbow-delimiters.nvim

### Treesitter (`plugins/treesitter.lua`)
- Syntax highlighting for 20+ languages
- Performance: Disabled for files >100KB or >5000 lines
- Incremental selection and textobjects disabled

### Completion (`plugins/completion.lua`)
- **Blink.cmp**: Fast completion with Rust fuzzy matching
- Auto-downloads prebuilt binaries (no compilation needed)
- Lazy-loads on LSP attach or Insert mode
- Optimized: 5 buffer items max, 2 char minimum

### Formatting (`plugins/formatting.lua`)
- **Conform.nvim**: Multi-formatter support
- Lazy-loads on first buffer enter
- Keymap: `<F3>` for formatting
- Supports: prettier, stylua, shfmt, rustfmt, etc.

### Colorizer (`plugins/colorizer.lua`)
- Color preview for CSS, HTML, JS, etc.
- Lazy-loads on FileType event
- Only 10 specific file types

### Editing (`plugins/editing.lua`)
- **Mini.surround**: `ys`, `ds`, `cs` mappings
- **Mini.pairs**: Auto-pairs with smart skipping

### LSP (`plugins/lsp.lua`)
- **Mason**: LSP package manager
- **18 LSP servers**: bashls, lua_ls, ts_ls, pyright, etc.
- Lazy-loads on BufReadPre/BufNewFile
- Performance: Semantic tokens disabled
- Full keymaps: Navigation, symbols, actions, diagnostics

## Adding New Plugins

### 1. Create a new module file
```lua
-- lua/nvx/plugins/myplugin.lua
return function(add, later, core)
  later(function()
    add({ source = 'author/plugin' })
    -- Plugin configuration here
  end)
end
```

### 2. Load it in `plugins.lua`
```lua
require('nvx.plugins.myplugin')(add, later, core)
```

## Performance Features

- ✅ Two-stage loading (NOW/LATER)
- ✅ Lazy-loading for heavy plugins
- ✅ Prebuilt binaries (no Rust compilation)
- ✅ Smart file size detection
- ✅ Minimal autocmds with proper cleanup
- ✅ Async operations (formatting, downloads)

## Commands

- `:DepsUpdate` - Update all plugins
- `:Mason` - Manage LSP servers

## Keymaps

### General
- `-` - Open Oil file explorer
- `<F3>` - Format buffer (normal/visual)

### LSP (when attached)
- `gd` - Go to definition
- `gr` - Go to references
- `gI` - Go to implementation
- `K` - Hover documentation
- `<leader>rn` - Rename
- `<leader>ca` - Code action
- `[d` / `]d` - Previous/next diagnostic

### Editing
- `ys{motion}{char}` - Add surround
- `ds{char}` - Delete surround
- `cs{old}{new}` - Change surround

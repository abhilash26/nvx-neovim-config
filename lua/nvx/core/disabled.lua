-- Disable unused built-in plugins for faster startup
local disabled_builtins = {
    '2html_plugin',      -- HTML conversion (rarely needed)
    'bugreport',         -- Bug reporting tool
    'getscript',         -- Outdated script downloading
    'getscriptPlugin',   -- Outdated script downloading
    'logipat',           -- Logical patterns (rarely used)
    'netrw',             -- File browser (replaced by Oil)
    'netrwFileHandlers', -- netrw file handlers
    'netrwPlugin',       -- netrw plugin
    'netrwSettings',     -- netrw settings
    'rrhelper',          -- Remote helper (rarely used)
    'tohtml',            -- HTML conversion
    'tutor',             -- vimtutor (one-time use)
    'vimball',           -- Outdated package format
    'vimballPlugin',     -- Outdated package format
}

for _, plugin in ipairs(disabled_builtins) do
    vim.g['loaded_' .. plugin] = 1
end

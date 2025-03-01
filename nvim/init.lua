require 'core.options' -- LOAD GENERAL OPTIONS
require 'core.keymaps' -- LOAD GENERAL KEYMAPS

-- SETUP LAZY PLUGIN MANAGER --
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then
        error('Error cloning lazy.nvim:\n' .. out)
    end
end
vim.opt.rtp:prepend(lazypath)

-- SETUP PLUGINS --
require('lazy').setup {
    -- NEO-TREE: A CUSTOMIZABLE FILE EXPLORER FOR NEOVIM (RIGHT SIDEBAR)
    require 'plugins.neotree',

    -- COLOR THEME: MANAGES THE COLOR SCHEME FOR NEOVIM
    require 'plugins.colortheme',

    -- BUFFERLINE: DISPLAYS OPEN TABS AS A BAR FOR SMOOTH NAVIGATION
    require 'plugins.bufferline',

    -- LUALINE: A CUSTOMIZABLE AND AESTHETIC STATUS BAR FOR NEOVIM
    require 'plugins.lualine',

    -- TREESITTER: ENHANCES SYNTAX HIGHLIGHTING AND CODE PARSING WITH ADVANCED ANALYSIS
    require 'plugins.treesitter',

    -- TELESCOPE: A POWERFUL FUZZY SEARCH ENGINE FOR FILES, BUFFERS, AND MORE
    require 'plugins.telescope',

    -- LSP (LANGUAGE SERVER PROTOCOL): PROVIDES ADVANCED SUPPORT FOR AUTOCOMPLETION, DIAGNOSTICS, AND LINTING
    require 'plugins.lsp',

    -- AUTO COMPLETION: CONFIGURES NATIVE LSP AND EXTERNAL SOURCES (LIKE CMP) TO PROVIDE CODE SUGGESTIONS IN REAL-TIME
    require 'plugins.autocompletion',

    -- NONE-LS: EXTENDS LSP CAPABILITIES WITH FORMATTERS, LINTERS, AND CODE ACTIONS WITHOUT AN EXTERNAL LANGUAGE SERVER
    require 'plugins.none-ls',

    -- GIT SIGNS: SHOWS GIT CHANGES DIRECTLY IN THE SIGN COLUMN (ADDITIONS, MODIFICATIONS, DELETIONS) WITH INLINE DIFFS
    require 'plugins.gitsigns',

    -- MISCELLANEOUS: CONTAINS VARIOUS SMALL UTILITIES AND ENHANCEMENTS
    require 'plugins.misc',
}

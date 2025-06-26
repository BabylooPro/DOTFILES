-- GLOBAL VARIABLES --
vim.g.opened_with_file = vim.fn.argc() > 0 -- CHECK IF NVIM WAS OPENED WITH A FILE ARGUMENT

-- NUMBERING & DISPLAY --
vim.wo.number = true -- ENABLE LINE NUMBERS (DEFAULT: FALSE)
vim.o.relativenumber = true -- ENABLE RELATIVE LINE NUMBERS (DEFAULT: FALSE)
vim.o.wrap = false -- DISPLAY LINES AS ONE LONG LINE (DEFAULT: TRUE)
vim.o.linebreak = true -- DO NOT SPLIT WORDS WHEN WRAPPING (DEFAULT: FALSE)
vim.o.cursorline = false -- DO NOT HIGHLIGHT THE CURRENT LINE (DEFAULT: FALSE)
vim.o.numberwidth = 4 -- SET NUMBER COLUMN WIDTH (DEFAULT: 4)
vim.wo.signcolumn = 'yes' -- KEEP SIGN COLUMN ENABLED (DEFAULT: 'AUTO')
vim.o.showtabline = 2 -- ALWAYS SHOW TABS (DEFAULT: 1)

-- USER INTERACTION --
vim.o.mouse = 'a' -- ENABLE MOUSE MODE (DEFAULT: '')
vim.o.clipboard = 'unnamedplus' -- SYNC CLIPBOARD BETWEEN OS AND NEOVIM (DEFAULT: '')
vim.o.whichwrap = 'bs<>[]hl' -- ALLOW CERTAIN KEYS TO NAVIGATE BETWEEN LINES (DEFAULT: 'B,S')
vim.o.backspace = 'indent,eol,start' -- ENABLE BACKSPACE FUNCTIONALITY (DEFAULT: 'INDENT,EOL,START')

-- INDENTATION --
vim.o.shiftwidth = 4 -- NUMBER OF SPACES FOR EACH INDENTATION (DEFAULT: 8)
vim.o.tabstop = 4 -- NUMBER OF SPACES FOR A TAB (DEFAULT: 8)
vim.o.softtabstop = 4 -- NUMBER OF SPACES A TAB COUNTS FOR WHILE EDITING (DEFAULT: 0)
vim.o.expandtab = true -- CONVERT TABS TO SPACES (DEFAULT: FALSE)

-- SEARCH & CASE SENSITIVITY --
vim.o.ignorecase = true -- CASE-INSENSITIVE SEARCH (DEFAULT: FALSE)
vim.o.smartcase = true -- SMART CASE SENSITIVITY (DEFAULT: FALSE)
vim.o.hlsearch = false -- DISABLE HIGHLIGHTING ON SEARCH (DEFAULT: TRUE)

-- SPLIT & WINDOW MANAGEMENT --
vim.o.splitbelow = true -- FORCE HORIZONTAL SPLITS TO GO BELOW (DEFAULT: FALSE)
vim.o.splitright = true -- FORCE VERTICAL SPLITS TO GO TO THE RIGHT (DEFAULT: FALSE)
vim.o.scrolloff = 4 -- MINIMUM LINES TO KEEP ABOVE AND BELOW CURSOR (DEFAULT: 0)
vim.o.sidescrolloff = 8 -- MINIMUM COLUMNS TO KEEP ON SIDES OF CURSOR (DEFAULT: 0)
vim.o.mousescroll = 'ver:1,hor:3' -- SMOOTHER MOUSE SCROLLING

-- APPEARANCE & UI --
vim.opt.termguicolors = true -- ENABLE TRUE COLOR SUPPORT (DEFAULT: FALSE)
vim.o.showmode = false -- HIDE MODE DISPLAY (DEFAULT: TRUE)
vim.opt.fillchars:append {
    vert = ' ', -- REMOVE VERTICAL SPLIT CHARACTER
    eob = ' ', -- REMOVE END-OF-BUFFER TILDES
}

-- FLOATING WINDOWS --
vim.opt.winblend = 0
vim.opt.pumblend = 0

-- SET HIGHLIGHT GROUPS --
vim.cmd([[
    highlight FloatBorder guifg=#9ca0a4 guibg=#2a2a2a
    highlight NormalFloat guibg=#2a2a2a
    highlight Pmenu guibg=#2a2a2a
    highlight PmenuSel guibg=#404040
]])

-- LSP WINDOWS --
vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
    config = config or {}
    config.border = border
    config.focusable = true
    vim.lsp.handlers.hover(_, result, ctx, config)
end
vim.lsp.handlers["textDocument/signatureHelp"] = function(_, result, ctx, config)
    config = config or {}
    config.border = border
    vim.lsp.handlers.signature_help(_, result, ctx, config)
end

-- DIAGNOSTICS WINDOWS --
vim.diagnostic.config({
    float = {
        border = border,
        source = true,
    },
    virtual_text = true,
})

-- OVERRIDE FLOATING WINDOW CREATION --
local win = require('vim.lsp.util').open_floating_preview
require('vim.lsp.util').open_floating_preview = function(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or border
    return win(contents, syntax, opts, ...)
end

-- PERFORMANCE & BACKUPS --
vim.o.updatetime = 250 -- DECREASE UPDATE TIME (DEFAULT: 4000)
vim.o.timeoutlen = 300 -- TIMEOUT FOR MAPPED SEQUENCES (IN MS) (DEFAULT: 1000)
vim.o.backup = false -- DISABLE BACKUP FILE CREATION (DEFAULT: FALSE)
vim.o.writebackup = false -- PREVENT EDITING IF FILE IS USED BY ANOTHER PROGRAM (DEFAULT: TRUE)
vim.o.undofile = true -- SAVE UNDO HISTORY (DEFAULT: FALSE)
vim.o.swapfile = false -- DISABLE SWAP FILE CREATION (DEFAULT: TRUE)

-- FILE & BUFFER SETTINGS --
vim.o.fileencoding = 'utf-8' -- SET FILE ENCODING TO UTF-8 (DEFAULT: 'UTF-8')
vim.o.cmdheight = 1 -- MORE SPACE IN COMMAND LINE FOR MESSAGES (DEFAULT: 1)
vim.o.completeopt = 'menuone,noselect' -- IMPROVE COMPLETION EXPERIENCE (DEFAULT: 'MENU,PREVIEW')

-- ADDITIONAL OPTIONS --
vim.o.smartindent = true -- ENABLE SMART INDENTATION (DEFAULT: FALSE)
vim.o.autoindent = true -- COPY INDENT FROM CURRENT LINE (DEFAULT: TRUE)
vim.o.breakindent = true -- ENABLE BREAK INDENT (DEFAULT: FALSE)
vim.o.conceallevel = 0 -- KEEP `` VISIBLE IN MARKDOWN (DEFAULT: 1)
vim.o.pumheight = 10 -- SET POPUP MENU HEIGHT (DEFAULT: 0)

-- FORMATTING & RUNTIME OPTIONS --
vim.opt.shortmess:append 'c' -- SUPPRESS COMPLETION MESSAGES (DEFAULT: DOES NOT INCLUDE 'C')
vim.opt.iskeyword:append '-' -- INCLUDE HYPHENATED WORDS IN SEARCHES (DEFAULT: DOES NOT INCLUDE '-')
vim.opt.formatoptions:remove { 'c', 'r', 'o' } -- DISABLE AUTO-INSERTING COMMENT LEADER (DEFAULT: 'CROQL')
vim.opt.runtimepath:remove '/usr/share/vim/vimfiles' -- SEPARATE VIM PLUGINS FROM NEOVIM (DEFAULT: INCLUDES THIS PATH IF VIM IS INSTALLED)

-- AUTO-SAVE ON FOCUS CHANGE --
local autosave_group = vim.api.nvim_create_augroup("AutoSave", { clear = true })
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave", "WinLeave", "InsertLeave" }, {
    group = autosave_group,
    callback = function()
        -- SAVE ALL MODIFIED BUFFERS WHEN FOCUS CHANGES (EXTERNAL OR INTERNAL) OR LEAVING INSERT MODE
        -- SILENT! SUPPRESSES ERRORS WHEN SAVING UNNAMED BUFFERS
        vim.cmd("silent! wall")
    end,
    desc = "AUTO-SAVE BUFFERS WHEN FOCUS CHANGES OR LEAVING INSERT MODE",
})

-- TERMINAL COLOR FIX --
vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    callback = function()
        vim.cmd("hi Terminal guibg=#202020")
        vim.cmd("hi TermCursor guibg=#D4D4D4 guifg=#202020")
        vim.cmd("setlocal winhighlight=Normal:Terminal")
    end,
})

-- USE OSC52 TO COPY TO SYSTEM CLIPBOARD OVER SSH; DISABLES PASTE; SETS UNNAMEDPLUS AS DEFAULT --
vim.g.clipboard = {
    name = "osc52",
    copy = {
        ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
        ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
        ["+"] = function() end,
        ["*"] = function() end,
    },
    cache_enabled = false,
}
vim.opt.clipboard = "unnamedplus"


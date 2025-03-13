-- LEADER KEY CONFIGURATION --
vim.g.mapleader = ' ' -- SET LEADER KEY TO SPACE
vim.g.maplocalleader = ' ' -- SET LOCAL LEADER KEY TO SPACE

-- DISABLE DEFAULT SPACEBAR BEHAVIOR --
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- GENERAL OPTIONS FOR MAPPINGS --
local opts = { noremap = true, silent = true }

-- FILE OPERATIONS --
vim.keymap.set('n', '<C-s>', '<cmd> w <CR>', opts) -- SAVE FILE
vim.keymap.set('n', '<leader>sn', '<cmd>noautocmd w <CR>', opts) -- SAVE FILE WITHOUT AUTO-FORMATTING
vim.keymap.set('n', '<C-q>', '<cmd> q <CR>', opts) -- QUIT FILE
vim.keymap.set('c', 'q', 'qa', {}) -- MAKE :q EXECUTE :qa

-- DELETE OPERATIONS --
vim.keymap.set('n', 'x', '"_x', opts) -- DELETE CHARACTER WITHOUT COPYING TO REGISTER

-- SCROLLING & CENTERING --
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts) -- SCROLL HALF PAGE DOWN AND CENTER
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts) -- SCROLL HALF PAGE UP AND CENTER

-- SEARCH & CENTERING --
vim.keymap.set('n', 'n', 'nzzzv', opts) -- FIND NEXT AND CENTER
vim.keymap.set('n', 'N', 'Nzzzv', opts) -- FIND PREVIOUS AND CENTER

-- RESIZE WINDOWS WITH ALT+ARROWS --
vim.keymap.set('n', '<A-Up>', ':resize -2<CR>', opts) -- DECREASE HEIGHT
vim.keymap.set('n', '<A-Down>', ':resize +2<CR>', opts) -- INCREASE HEIGHT
vim.keymap.set('n', '<A-Left>', ':vertical resize -2<CR>', opts) -- DECREASE WIDTH
vim.keymap.set('n', '<A-Right>', ':vertical resize +2<CR>', opts) -- INCREASE WIDTH

-- STANDARD ARROW KEY NAVIGATION --
vim.keymap.set('n', '<Up>', 'k', { noremap = true, silent = true }) -- NORMAL UP MOVEMENT
vim.keymap.set('n', '<Down>', 'j', { noremap = true, silent = true }) -- NORMAL DOWN MOVEMENT
vim.keymap.set('n', '<Left>', 'h', { noremap = true, silent = true }) -- NORMAL LEFT MOVEMENT
vim.keymap.set('n', '<Right>', 'l', { noremap = true, silent = true }) -- NORMAL RIGHT MOVEMENT

-- BUFFER MANAGEMENT --
vim.keymap.set('n', '<Tab>', ':bnext<CR>', opts) -- SWITCH TO NEXT BUFFER
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts) -- SWITCH TO PREVIOUS BUFFER
vim.keymap.set('n', '<leader>x', ':Bdelete!<CR>', opts) -- CLOSE BUFFER WITH BUFFERLINE
vim.keymap.set('n', '<leader>b', '<cmd> enew <CR>', opts) -- CREATE NEW BUFFER

-- WINDOW MANAGEMENT --
vim.keymap.set('n', '<leader>v', '<C-w>v', opts) -- SPLIT WINDOW VERTICALLY
vim.keymap.set('n', '<leader>h', '<C-w>s', opts) -- SPLIT WINDOW HORIZONTALLY
vim.keymap.set('n', '<leader>se', '<C-w>=', opts) -- EQUALIZE WINDOW SIZES
vim.keymap.set('n', '<leader>xs', ':close<CR>', opts) -- CLOSE CURRENT SPLIT WINDOW

-- NAVIGATE BETWEEN SPLITS --
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', opts) -- MOVE TO UPPER SPLIT
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', opts) -- MOVE TO LOWER SPLIT
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', opts) -- MOVE TO LEFT SPLIT
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', opts) -- MOVE TO RIGHT SPLIT

-- TAB MANAGEMENT --
vim.keymap.set('n', '<leader>to', ':tabnew<CR>', opts) -- OPEN NEW TAB
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', opts) -- CLOSE CURRENT TAB
vim.keymap.set('n', '<leader>tn', ':tabn<CR>', opts) -- GO TO NEXT TAB
vim.keymap.set('n', '<leader>tp', ':tabp<CR>', opts) -- GO TO PREVIOUS TAB

-- TOGGLE LINE WRAPPING --
vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', opts) -- TOGGLE WRAP MODE

-- STAY IN INDENT MODE --
vim.keymap.set('v', '<', '<gv', opts) -- DECREASE INDENT AND KEEP VISUAL MODE
vim.keymap.set('v', '>', '>gv', opts) -- INCREASE INDENT AND KEEP VISUAL MODE

-- KEEP LAST YANKED WHEN PASTING --
vim.keymap.set('v', 'p', '"_dP', opts) -- PASTE WITHOUT OVERWRITING REGISTER

-- DIAGNOSTIC KEYMAPS --
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'GO TO PREVIOUS DIAGNOSTIC MESSAGE' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'GO TO NEXT DIAGNOSTIC MESSAGE' })
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'OPEN FLOATING DIAGNOSTIC MESSAGE' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'OPEN DIAGNOSTICS LIST' })

-- COMMENT KEYMAPS TOGGLE FUNCTIONS IN 2 MODE
local function toggle_comment_line()
    local comment_api = require('Comment.api')
    comment_api.toggle.linewise.current()
end
local function toggle_comment_visual()
    local comment_api = require('Comment.api')
    local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
    vim.api.nvim_feedkeys(esc, 'nx', false)
    comment_api.toggle.linewise(vim.fn.visualmode())
end

-- FALLBACK COMMENT KEYMAPS (WORKS EVERYWHERE)
vim.keymap.set('n', '<leader>cc', toggle_comment_line, { desc = 'COMMENT TOGGLE CURRENT LINE' })
vim.keymap.set('v', '<leader>cc', toggle_comment_visual, { desc = 'COMMENT TOGGLE VISUAL SELECTION' })

-- FIX FOR COMMENT.NVIM INTERFERING WITH VISUAL MODE CLIPBOARD OPERATIONS
vim.keymap.set('v', 'd', 'd', { noremap = true, desc = 'ENSURE VISUAL DELETE USES DEFAULT BEHAVIOR' })


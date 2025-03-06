return {
    'folke/snacks.nvim',
    lazy = false,
    priority = 1000,
    event = 'VeryLazy',
    dependencies = {
        'MunifTanjim/nui.nvim',
        'nvim-telescope/telescope.nvim',
    },
    opts = {
        -- DEFAULT CONFIGURATION
        notifier = {
            -- NOTIFICATION SETTINGS - CONTROLS HOW NOTIFICATIONS APPEAR AND BEHAVE
            level = vim.log.levels.INFO,
            timeout = 3000,
            max_width = 80,
            max_height = 20,
            stages = 'fade', -- ANIMATION STYLE: "fade", "slide", "static"
            top_down = true, -- DIRECTION OF NOTIFICATIONS
        },
        picker = {
            -- TELESCOPE INTEGRATION SETTINGS - CONFIGURES THE APPEARANCE OF TELESCOPE PICKERS
            layout_strategy = 'center',
            layout_config = {
                width = 0.8,
                height = 0.6,
            },
        },
        terminal = {
            -- TERMINAL SETTINGS - CONFIGURES THE BUILT-IN TERMINAL FUNCTIONALITY
            direction = 'float', -- "float", "horizontal", "vertical"
            auto_insert = true,
            close_on_exit = true,
            win = {
                width = 0.4,
                height = 0.25,
                row = 0.9,
                col = 0.5,
                border = 'single',
                winblend = 0,
                style = 'minimal',
            },
        },
        zen = {
            -- ZEN MODE SETTINGS - CREATES A DISTRACTION-FREE EDITING ENVIRONMENT
            enabled = true,
            kitty_enabled = false,
            backdrop = 0.9, -- TRANSPARENCY OF BACKDROP (0-1)
            width = 0.7, -- WIDTH OF TEXT AREA (0-1)
        },
        -- ENABLE ADDITIONAL MODULES - EACH MODULE ADDS SPECIFIC FUNCTIONALITY
        bigfile = { enabled = true }, -- OPTIMIZES PERFORMANCE FOR LARGE FILES
        words = { enabled = true }, -- ENABLES SMART WORD NAVIGATION
        scroll = { enabled = false }, -- ENABLES SMOOTH SCROLLING
        statuscolumn = { enabled = false }, -- ENHANCES THE STATUS COLUMN WITH USEFUL INFO
        quickfile = { enabled = true }, -- PROVIDES QUICK ACCESS TO FILES
        scope = { enabled = true }, -- VISUALIZES CODE SCOPE
        input = { enabled = true }, -- ENHANCES INPUT UI
        dashboard = {
            enabled = true, -- ADDS A START SCREEN DASHBOARD
            mouse_enabled = false, -- DISABLES MOUSE INTERACTION IN DASHBOARD
            sections = {
                { section = 'header' },
                {
                    pane = 2,
                    icon = ' ',
                    section = 'terminal',
                    title = 'Keybindings Tips',
                    cmd = "while true; do clear; echo -e'  <leader>ff    Find Files\\n  <leader>fg    Find in Git Files\\n  <leader>fr    Recent Files\\n  <leader>fb    Find Buffers\\n  <leader>sg    Search (Grep)\\n  <leader>sw    Search Word\\n  <leader>sb    Search Buffer\\n  <leader>z     Toggle Zen Mode\\n  <leader>e     Explorer\\n  <leader>d     Dashboard\\n  <leader>gg    LazyGit\\n  <leader>gb    Git Branches\\n  <leader>gs    Git Status' | sort -R | head -n 1; sleep 5; done",
                    height = 2,
                    padding = 1,
                },
                { section = 'keys', gap = 1, padding = 1 },
                { pane = 2, icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
                { pane = 2, icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
                {
                    pane = 2,
                    icon = ' ',
                    title = 'Git Status',
                    section = 'terminal',
                    enabled = function()
                        return require('snacks').git.get_root() ~= nil
                    end,
                    cmd = 'git status --short --branch --renames',
                    height = 3,
                    padding = 0,
                    ttl = 5 * 60,
                    indent = 3,
                },
                {
                    pane = 2,
                    icon = ' ',
                    title = 'Git Log',
                    section = 'terminal',
                    enabled = function()
                        return require('snacks').git.get_root() ~= nil
                    end,
                    cmd = 'git --no-pager log --oneline --graph --decorate origin/$(git rev-parse --abbrev-ref HEAD)..HEAD',
                    height = 5,
                    padding = 1,
                    ttl = 5 * 60,
                    indent = 3,
                },
                { section = 'startup' },
            },
        },
        explorer = {
            enabled = true, -- ADDS A FILE EXPLORER
            float = {
                width = 0.8,
                height = 0.8,
            },
        },
        -- ADD STYLES FOR NOTIFICATIONS - CUSTOMIZE NOTIFICATION APPEARANCE
        styles = {
            notification = {
                -- wo = { wrap = true } -- UNCOMMENT TO WRAP NOTIFICATIONS
            },
        },
        -- ENABLE INDENT MODULE - PROVIDES VISUAL INDENTATION GUIDES
        indent = { enabled = false },
    },
    keys = require 'plugins.snacks-keymaps',
    init = function()
        -- DISABLE MOUSE GLOBALLY
        vim.opt.mouse = ''

        -- SHOW DASHBOARD ON STARTUP
        vim.api.nvim_create_autocmd('VimEnter', {
            callback = function()
                -- ONLY SHOW DASHBOARD WHEN STARTING NEOVIM WITHOUT ARGUMENTS
                if vim.fn.argc() == 0 and vim.fn.line2byte '$' == -1 then
                    require('snacks').dashboard()
                end
            end,
            group = vim.api.nvim_create_augroup('SnacksDashboardOnStartup', { clear = true }),
            desc = 'Show snacks dashboard on startup',
        })

        vim.api.nvim_create_autocmd('User', {
            pattern = 'VeryLazy',
            callback = function()
                -- SETUP DEBUGGING HELPERS
                -- FUNCTION TO INSPECT VARIABLES (DEBUGGING)
                -- PROVIDES DETAILED INSPECTION OF ANY VARIABLE OR TABLE
                _G.dd = function(...)
                    require('snacks').debug.inspect(...)
                end
                -- FUNCTION TO DISPLAY CALL TRACE (DEBUGGING)
                -- SHOWS THE EXECUTION STACK FOR DEBUGGING
                _G.bt = function()
                    require('snacks').debug.backtrace()
                end

                -- CREATE TOGGLE MAPPINGS
                local toggle = require('snacks').toggle
                -- TOGGLES SPELL CHECKING
                -- ENABLES/DISABLES SPELL CHECKING FOR THE CURRENT BUFFER
                toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
                -- TOGGLES LINE WRAPPING
                -- ENABLES/DISABLES TEXT WRAPPING AT THE WINDOW EDGE
                toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
                -- TOGGLES RELATIVE LINE NUMBERS
                -- SWITCHES BETWEEN ABSOLUTE AND RELATIVE LINE NUMBERING
                toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>uL'
                -- TOGGLES LSP DIAGNOSTICS
                -- ENABLES/DISABLES ERROR AND WARNING MESSAGES
                toggle.diagnostics():map '<leader>ud'
                -- TOGGLES LINE NUMBERS
                -- SHOWS/HIDES LINE NUMBERS IN THE GUTTER
                toggle.line_number():map '<leader>ul'
                -- TOGGLES TEXT CONCEALMENT (MARKDOWN, ETC.)
                -- CONTROLS HOW MARKUP IS DISPLAYED (E.G., HIDING MARKDOWN SYNTAX)
                toggle
                    .option('conceallevel', {
                        off = 0,
                        on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
                    })
                    :map '<leader>uc'
                -- TOGGLES TREESITTER
                -- ENABLES/DISABLES ADVANCED SYNTAX HIGHLIGHTING
                toggle.treesitter():map '<leader>uT'
                -- TOGGLES BETWEEN LIGHT AND DARK THEME
                -- SWITCHES COLOR SCHEME BETWEEN LIGHT AND DARK VARIANTS
                toggle
                    .option('background', {
                        off = 'light',
                        on = 'dark',
                        name = 'Dark Background',
                    })
                    :map '<leader>ub'
                -- TOGGLES INLAY HINTS
                -- SHOWS/HIDES INLINE TYPE HINTS FROM LSP
                toggle.inlay_hints():map '<leader>uh'
                -- TOGGLES INDENTATION GUIDES
                -- SHOWS/HIDES VISUAL GUIDES FOR CODE INDENTATION
                toggle.indent():map '<leader>ug'
                -- TOGGLES DIMMING OF OUT-OF-FOCUS CODE
                -- DIMS CODE OUTSIDE THE CURRENT SCOPE FOR BETTER FOCUS
                toggle.dim():map '<leader>uD'

                -- OVERRIDE PRINT TO USE SNACKS FOR `:=` COMMAND
                -- REPLACES THE DEFAULT PRINT WITH THE ENHANCED SNACKS VERSION
                vim.print = _G.dd
            end,
        })
    end,
}

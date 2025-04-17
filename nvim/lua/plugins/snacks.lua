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
                bg = '#202020',  -- EXPLICITLY SET BACKGROUND COLOR
            },
            highlights = {
                Normal = { bg = '#202020', fg = '#D4D4D4' },
                NormalFloat = { bg = '#202020' },
                FloatBorder = { bg = '#202020', fg = '#353535' },
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
                { section = 'keys', gap = 1, padding = 1 },
                { section = 'startup' },
                {
                    section = 'terminal',
                    cmd = [[
                      # GET ONLY PROJECT NAME FROM PATH
                      project_path=$(echo $PWD | sed "s|$HOME/||" | sed 's/.*\///')
                      green=$(tput setaf 2)
                      blue=$(tput setaf 4)
                      reset=$(tput sgr0)
                      text_colored="${green}📁 $project_path${reset} - ${blue}👤 $(git config user.name)${reset}"
                      text_length=$(echo "📁 $project_path - 👤 $(git config user.name)" | wc -m)
                      cols=$(tput cols)
                      spaces=$(( ($cols - $text_length) / 2 ))
                      printf "%${spaces}s%s\n" "" "$text_colored"
                    ]],
                    height = 1,
                    padding = 1,
                },
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

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
            float = {
                width = 0.8,
                height = 0.6,
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
    keys = {
        -- BASIC KEYMAPS
        {
            -- ACTIVATES ZEN MODE (HIDES UI ELEMENTS FOR DISTRACTION-FREE EDITING)
            -- REMOVES DISTRACTIONS BY HIDING LINE NUMBERS, STATUS LINE, AND OTHER UI ELEMENTS
            '<leader>z',
            function()
                require('snacks').zen()
            end,
            desc = 'Toggle Zen Mode',
        },
        {
            -- ZOOMS ON THE CURRENT WINDOW (MAXIMIZES THE CURRENT WINDOW)
            -- EXPANDS THE CURRENT WINDOW TO TAKE UP MORE SCREEN SPACE WITHOUT ENTERING FULL ZEN MODE
            '<leader>Z',
            function()
                require('snacks').zen.zoom()
            end,
            desc = 'Toggle Zoom',
        },
        {
            -- DISPLAYS NOTIFICATION HISTORY
            -- SHOWS A LIST OF ALL RECENT NOTIFICATIONS FOR REVIEW
            '<leader>n',
            function()
                require('snacks').notifier.show_history()
            end,
            desc = 'Notification History',
        },
        {
            -- HIDES ALL ACTIVE NOTIFICATIONS
            -- CLEARS ALL CURRENTLY VISIBLE NOTIFICATIONS FROM THE SCREEN
            '<leader>un',
            function()
                require('snacks').notifier.hide()
            end,
            desc = 'Dismiss All Notifications',
        },
        {
            -- OPENS/CLOSES A FLOATING TERMINAL
            -- TOGGLES A TERMINAL WINDOW THAT FLOATS ABOVE THE EDITOR
            '<leader>t',
            function()
                require('snacks').terminal()
            end,
            desc = 'Toggle Terminal',
        },
        {
            -- ALTERNATIVE TERMINAL MAPPING
            -- ALTERNATIVE WAY TO TOGGLE THE TERMINAL
            '<A-i>',
            function()
                require('snacks').terminal()
            end,
            desc = 'Toggle Terminal',
        },

        -- FILE NAVIGATION --
        {
            -- DISPLAYS RECENTLY OPENED FILES
            -- SHOWS A LIST OF FILES YOU'VE RECENTLY WORKED WITH FOR QUICK ACCESS
            '<leader>fr',
            function()
                require('snacks').picker.recent()
            end,
            desc = 'Recent Files',
        },
        {
            -- SEARCHES FOR FILES IN THE CURRENT DIRECTORY
            -- FUZZY FINDER FOR LOCATING FILES IN THE CURRENT PROJECT
            '<leader>ff',
            function()
                require('snacks').picker.files()
            end,
            desc = 'Find Files',
        },
        {
            -- SEARCHES FOR FILES IN THE GIT REPOSITORY
            -- FUZZY FINDER THAT ONLY SHOWS FILES TRACKED BY GIT (IGNORES .GITIGNORE FILES)
            '<leader>fg',
            function()
                require('snacks').picker.git_files()
            end,
            desc = 'Find Git Files',
        },
        {
            -- DISPLAYS AND NAVIGATES BETWEEN OPEN BUFFERS
            -- SHOWS ALL CURRENTLY OPEN FILES FOR QUICK SWITCHING
            '<leader>fb',
            function()
                require('snacks').picker.buffers()
            end,
            desc = 'Find Buffers',
        },
        {
            -- DISPLAYS AND NAVIGATES BETWEEN PROJECTS
            -- SHOWS A LIST OF PROJECTS FOR QUICK SWITCHING BETWEEN CODEBASES
            '<leader>fp',
            function()
                require('snacks').picker.projects()
            end,
            desc = 'Projects',
        },

        -- SEARCH
        {
            -- SEARCHES FOR TEXT IN FILES (RIPGREP)
            -- PERFORMS A FULL-TEXT SEARCH ACROSS ALL FILES IN THE PROJECT
            '<leader>sg',
            function()
                require('snacks').picker.grep()
            end,
            desc = 'Grep',
        },
        {
            -- SEARCHES FOR THE WORD UNDER CURSOR IN FILES
            -- FINDS ALL OCCURRENCES OF THE CURRENT WORD ACROSS THE PROJECT
            '<leader>sw',
            function()
                require('snacks').picker.grep_word()
            end,
            desc = 'Grep Word',
            mode = { 'n', 'x' },
        },
        {
            -- SEARCHES FOR LINES IN THE CURRENT BUFFER
            -- FUZZY SEARCH THROUGH THE LINES OF THE CURRENT FILE
            '<leader>sb',
            function()
                require('snacks').picker.lines()
            end,
            desc = 'Buffer Lines',
        },
        {
            -- SEARCHES FOR TEXT IN ALL OPEN BUFFERS
            -- PERFORMS TEXT SEARCH ONLY IN CURRENTLY OPEN FILES
            '<leader>sB',
            function()
                require('snacks').picker.grep_buffers()
            end,
            desc = 'Grep Buffers',
        },
        {
            -- SEARCHES IN NEOVIM HELP PAGES
            -- FUZZY SEARCH THROUGH NEOVIM'S DOCUMENTATION
            '<leader>sh',
            function()
                require('snacks').picker.help()
            end,
            desc = 'Help Pages',
        },
        {
            -- DISPLAYS ALL KEY MAPPINGS
            -- SHOWS ALL CONFIGURED KEYBOARD SHORTCUTS
            '<leader>sk',
            function()
                require('snacks').picker.keymaps()
            end,
            desc = 'Keymaps',
        },
        {
            -- DISPLAYS ALL SYNTAX HIGHLIGHTING GROUPS
            -- SHOWS ALL COLOR GROUPS FOR THEME CUSTOMIZATION
            '<leader>sH',
            function()
                require('snacks').picker.highlights()
            end,
            desc = 'Highlights',
        },

        -- GIT INTEGRATION
        {
            -- OPENS LAZYGIT INTERFACE (TUI GIT CLIENT)
            -- LAUNCHES THE TERMINAL UI FOR GIT WITH COMPREHENSIVE FEATURES
            '<leader>gg',
            function()
                require('snacks').lazygit()
            end,
            desc = 'Lazygit',
        },
        {
            -- OPENS CURRENT FILE/COMMIT IN BROWSER (GITHUB, GITLAB, ETC.)
            -- OPENS THE WEB INTERFACE FOR THE CURRENT FILE OR SELECTED LINES
            '<leader>gB',
            function()
                require('snacks').gitbrowse()
            end,
            desc = 'Git Browse',
            mode = { 'n', 'v' },
        },
        {
            -- DISPLAYS AND ALLOWS SWITCHING GIT BRANCHES
            -- SHOWS ALL BRANCHES AND LETS YOU CHECKOUT A DIFFERENT ONE
            '<leader>gb',
            function()
                require('snacks').picker.git_branches()
            end,
            desc = 'Git Branches',
        },
        {
            -- DISPLAYS COMMIT HISTORY
            -- SHOWS THE FULL COMMIT HISTORY WITH DETAILS
            '<leader>gl',
            function()
                require('snacks').picker.git_log()
            end,
            desc = 'Git Log',
        },
        {
            -- DISPLAYS COMMIT HISTORY FOR THE CURRENT LINE
            -- SHOWS WHICH COMMITS MODIFIED THE CURRENT LINE (BLAME)
            '<leader>gL',
            function()
                require('snacks').picker.git_log_line()
            end,
            desc = 'Git Log Line',
        },
        {
            -- DISPLAYS MODIFIED FILES
            -- SHOWS ALL FILES WITH UNCOMMITTED CHANGES
            '<leader>gs',
            function()
                require('snacks').picker.git_status()
            end,
            desc = 'Git Status',
        },
        {
            -- DISPLAYS AND MANAGES GIT STASHES
            -- SHOWS SAVED STASHES AND ALLOWS APPLYING OR DROPPING THEM
            '<leader>gS',
            function()
                require('snacks').picker.git_stash()
            end,
            desc = 'Git Stash',
        },
        {
            -- DISPLAYS GIT DIFFERENCES BY HUNKS
            -- SHOWS CHANGES BETWEEN WORKING DIRECTORY AND INDEX
            '<leader>gd',
            function()
                require('snacks').picker.git_diff()
            end,
            desc = 'Git Diff (Hunks)',
        },

        -- BUFFER MANAGEMENT
        {
            -- DELETES THE CURRENT BUFFER WITHOUT DISRUPTING LAYOUT
            -- CLOSES THE CURRENT FILE WITHOUT CLOSING THE WINDOW
            '<leader>bd',
            function()
                require('snacks').bufdelete()
            end,
            desc = 'Delete Buffer',
        },
        {
            -- OPENS/CLOSES A TEMPORARY BUFFER FOR NOTES
            -- CREATES A SCRATCH PAD FOR TEMPORARY TEXT THAT WON'T BE SAVED
            '<leader>.',
            function()
                require('snacks').scratch()
            end,
            desc = 'Toggle Scratch Buffer',
        },
        {
            -- SELECTS A SCRATCH BUFFER FROM EXISTING ONES
            -- ALLOWS SWITCHING BETWEEN MULTIPLE SCRATCH PADS
            '<leader>S',
            function()
                require('snacks').scratch.select()
            end,
            desc = 'Select Scratch Buffer',
        },

        -- WORD NAVIGATION (NEWLY ENABLED)
        {
            -- JUMPS TO THE NEXT REFERENCE OF THE WORD UNDER CURSOR
            -- FINDS THE NEXT OCCURRENCE OF THE CURRENT WORD WITHOUT SEARCHING
            ']]',
            function()
                require('snacks').words.jump(vim.v.count1)
            end,
            desc = 'Next Reference',
            mode = { 'n', 'x' },
        },
        {
            -- JUMPS TO THE PREVIOUS REFERENCE OF THE WORD UNDER CURSOR
            -- FINDS THE PREVIOUS OCCURRENCE OF THE CURRENT WORD WITHOUT SEARCHING
            '[[',
            function()
                require('snacks').words.jump(-vim.v.count1)
            end,
            desc = 'Prev Reference',
            mode = { 'n', 'x' },
        },

        -- EXPLORER (NEWLY ENABLED)
        {
            -- OPENS THE FILE EXPLORER
            -- LAUNCHES A FILE BROWSER FOR NAVIGATING THE PROJECT STRUCTURE
            '<leader>e',
            function()
                require('snacks').explorer()
            end,
            desc = 'Explorer',
        },

        -- QUICKFILE (NEWLY ENABLED)
        {
            -- QUICKLY OPENS A FILE (USEFUL FOR LARGE FILES)
            -- OPTIMIZED FILE OPENER THAT HANDLES LARGE FILES EFFICIENTLY
            '<leader>q',
            function()
                require('snacks').quickfile()
            end,
            desc = 'Quick File',
        },

        -- SCOPE (NEWLY ENABLED)
        {
            -- TOGGLES CODE SCOPE VISUALIZATION
            -- HIGHLIGHTS THE CURRENT SCOPE (FUNCTION, BLOCK, ETC.)
            '<leader>sc',
            function()
                require('snacks').scope()
            end,
            desc = 'Toggle Scope',
        },

        -- DASHBOARD (NEWLY ENABLED)
        {
            -- OPENS THE START DASHBOARD
            -- SHOWS A WELCOME SCREEN WITH RECENT FILES AND SESSIONS
            '<leader>d',
            function()
                require('snacks').dashboard()
            end,
            desc = 'Dashboard',
        },

        -- LSP NAVIGATION
        {
            -- GOES TO THE DEFINITION OF THE SYMBOL UNDER CURSOR
            -- JUMPS TO WHERE THE CURRENT SYMBOL IS DEFINED
            'gd',
            function()
                require('snacks').picker.lsp_definitions()
            end,
            desc = 'Goto Definition',
        },
        {
            -- GOES TO THE DECLARATION OF THE SYMBOL UNDER CURSOR
            -- JUMPS TO WHERE THE CURRENT SYMBOL IS DECLARED
            'gD',
            function()
                require('snacks').picker.lsp_declarations()
            end,
            desc = 'Goto Declaration',
        },
        {
            -- DISPLAYS ALL REFERENCES OF THE SYMBOL UNDER CURSOR
            -- SHOWS ALL PLACES WHERE THE CURRENT SYMBOL IS USED
            'gr',
            function()
                require('snacks').picker.lsp_references()
            end,
            desc = 'References',
        },
        {
            -- GOES TO THE IMPLEMENTATION OF THE SYMBOL UNDER CURSOR
            -- JUMPS TO THE IMPLEMENTATION OF AN INTERFACE OR ABSTRACT METHOD
            'gI',
            function()
                require('snacks').picker.lsp_implementations()
            end,
            desc = 'Goto Implementation',
        },
        {
            -- GOES TO THE TYPE DEFINITION OF THE SYMBOL UNDER CURSOR
            -- JUMPS TO WHERE THE TYPE OF THE CURRENT SYMBOL IS DEFINED
            'gy',
            function()
                require('snacks').picker.lsp_type_definitions()
            end,
            desc = 'Goto Type Definition',
        },
        {
            -- DISPLAYS ALL SYMBOLS IN THE CURRENT FILE
            -- SHOWS A LIST OF FUNCTIONS, CLASSES, VARIABLES IN THE CURRENT FILE
            '<leader>ss',
            function()
                require('snacks').picker.lsp_symbols()
            end,
            desc = 'LSP Symbols',
        },
        {
            -- DISPLAYS ALL SYMBOLS IN THE WORKSPACE
            -- SHOWS SYMBOLS ACROSS THE ENTIRE PROJECT
            '<leader>sS',
            function()
                require('snacks').picker.lsp_workspace_symbols()
            end,
            desc = 'LSP Workspace Symbols',
        },
        {
            -- DISPLAYS ALL DIAGNOSTICS IN THE WORKSPACE
            -- SHOWS ERRORS AND WARNINGS ACROSS THE ENTIRE PROJECT
            '<leader>sd',
            function()
                require('snacks').picker.diagnostics()
            end,
            desc = 'Diagnostics',
        },
        {
            -- DISPLAYS DIAGNOSTICS IN THE CURRENT BUFFER
            -- SHOWS ERRORS AND WARNINGS ONLY IN THE CURRENT FILE
            '<leader>sD',
            function()
                require('snacks').picker.diagnostics_buffer()
            end,
            desc = 'Buffer Diagnostics',
        },
        {
            -- RENAMES THE CURRENT FILE (WITH LSP SUPPORT)
            -- RENAMES THE FILE AND UPDATES ALL REFERENCES TO IT
            '<leader>cR',
            function()
                require('snacks').rename.rename_file()
            end,
            desc = 'Rename File',
        },

        --! DISABLED BECAUSE IT'S CAUSE CONFUSION WITH <leader> DEFINE IN SPACE KEYMAP
        -- ADD SMART PICKER
        -- {
        --     -- INTELLIGENT FILE SEARCH (ADAPTS SEARCH TO CONTEXT)
        --     -- AUTOMATICALLY CHOOSES THE BEST SEARCH METHOD BASED ON CONTEXT
        --     '<leader><space>',
        --     function()
        --         require('snacks').picker.smart()
        --     end,
        --     desc = 'Smart Find Files',
        -- },

        -- ADD COMMAND HISTORY PICKER
        {
            -- DISPLAYS COMMAND HISTORY
            -- SHOWS PREVIOUSLY EXECUTED COMMANDS FOR REUSE
            '<leader>:',
            function()
                require('snacks').picker.command_history()
            end,
            desc = 'Command History',
        },

        -- ADD COLORSCHEME PICKER
        {
            -- DISPLAYS AND ALLOWS CHANGING COLOR THEMES
            -- PREVIEWS AND APPLIES DIFFERENT COLOR SCHEMES
            '<leader>uC',
            function()
                require('snacks').picker.colorschemes()
            end,
            desc = 'Colorschemes',
        },

        -- ADD NEOVIM NEWS
        {
            -- DISPLAYS NEOVIM NEWS
            -- SHOWS THE LATEST UPDATES AND CHANGES IN NEOVIM
            '<leader>N',
            desc = 'Neovim News',
            function()
                require('snacks').win {
                    file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1],
                    width = 0.6,
                    height = 0.6,
                    wo = {
                        spell = false,
                        wrap = false,
                        signcolumn = 'yes',
                        statuscolumn = ' ',
                        conceallevel = 3,
                    },
                }
            end,
        },

        -- ADD FIND CONFIG FILE
        {
            -- SEARCHES FOR FILES IN THE CONFIGURATION DIRECTORY
            -- HELPS LOCATE AND EDIT NEOVIM CONFIGURATION FILES
            '<leader>fc',
            function()
                require('snacks').picker.files { cwd = vim.fn.stdpath 'config' }
            end,
            desc = 'Find Config File',
        },

        -- ADD GIT LOG FILE
        {
            -- DISPLAYS GIT HISTORY FOR THE CURRENT FILE
            -- SHOWS ALL COMMITS THAT MODIFIED THE CURRENT FILE
            '<leader>gf',
            function()
                require('snacks').picker.git_log_file()
            end,
            desc = 'Git Log File',
        },

        -- ADD REGISTERS PICKER
        {
            -- DISPLAYS REGISTER CONTENTS
            -- SHOWS THE CONTENT OF ALL REGISTERS FOR PASTING
            '<leader>s"',
            function()
                require('snacks').picker.registers()
            end,
            desc = 'Registers',
        },

        -- ADD SEARCH HISTORY PICKER
        {
            -- DISPLAYS SEARCH HISTORY
            -- SHOWS PREVIOUS SEARCH PATTERNS FOR REUSE
            '<leader>s/',
            function()
                require('snacks').picker.search_history()
            end,
            desc = 'Search History',
        },

        -- ADD AUTOCMDS PICKER
        {
            -- DISPLAYS ALL AUTOCOMMANDS
            -- SHOWS ALL CONFIGURED AUTOMATIC COMMANDS
            '<leader>sa',
            function()
                require('snacks').picker.autocmds()
            end,
            desc = 'Autocmds',
        },

        -- ADD ICONS PICKER
        {
            -- DISPLAYS AND ALLOWS SEARCHING FOR ICONS
            -- HELPS FIND AND INSERT SPECIAL ICONS AND SYMBOLS
            '<leader>si',
            function()
                require('snacks').picker.icons()
            end,
            desc = 'Icons',
        },

        -- ADD JUMPS PICKER
        {
            -- DISPLAYS THE JUMP LIST
            -- SHOWS NAVIGATION HISTORY FOR JUMPING BACK AND FORTH
            '<leader>sj',
            function()
                require('snacks').picker.jumps()
            end,
            desc = 'Jumps',
        },

        -- ADD LOCATION LIST PICKER
        {
            -- DISPLAYS THE LOCATION LIST
            -- SHOWS THE CURRENT LOCATION LIST (SIMILAR TO QUICKFIX)
            '<leader>sl',
            function()
                require('snacks').picker.loclist()
            end,
            desc = 'Location List',
        },

        -- ADD MARKS PICKER
        {
            -- DISPLAYS ALL MARKS
            -- SHOWS ALL SET MARKS FOR QUICK NAVIGATION
            '<leader>sm',
            function()
                require('snacks').picker.marks()
            end,
            desc = 'Marks',
        },

        -- ADD MAN PAGES PICKER
        {
            -- SEARCHES IN MAN PAGES
            -- BROWSE AND SEARCH SYSTEM MANUAL PAGES
            '<leader>sM',
            function()
                require('snacks').picker.man()
            end,
            desc = 'Man Pages',
        },

        -- ADD LAZY PLUGIN SPEC PICKER
        {
            -- SEARCHES IN PLUGIN SPECIFICATIONS
            -- HELPS FIND AND NAVIGATE PLUGIN CONFIGURATIONS
            '<leader>sp',
            function()
                require('snacks').picker.lazy()
            end,
            desc = 'Search for Plugin Spec',
        },

        -- ADD QUICKFIX LIST PICKER
        {
            -- DISPLAYS THE QUICKFIX LIST
            -- SHOWS THE CURRENT QUICKFIX LIST FOR NAVIGATION
            '<leader>sq',
            function()
                require('snacks').picker.qflist()
            end,
            desc = 'Quickfix List',
        },

        -- ADD RESUME PICKER
        {
            -- RESUMES THE LAST TELESCOPE SEARCH
            -- REOPENS THE LAST SEARCH RESULT WITHOUT REPEATING THE SEARCH
            '<leader>sR',
            function()
                require('snacks').picker.resume()
            end,
            desc = 'Resume',
        },

        -- ADD UNDO HISTORY PICKER
        {
            -- DISPLAYS UNDO HISTORY
            -- VISUALIZES THE UNDO TREE FOR NAVIGATING CHANGES
            '<leader>su',
            function()
                require('snacks').picker.undo()
            end,
            desc = 'Undo History',
        },
    },
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

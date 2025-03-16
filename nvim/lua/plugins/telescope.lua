return {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        { -- IF ENCOUNTERING ERRORS, SEE TELESCOPE-FZF-NATIVE README FOR INSTALLATION INSTRUCTIONS
            'nvim-telescope/telescope-fzf-native.nvim',

            -- `build` IS USED TO RUN SOME COMMAND WHEN THE PLUGIN IS INSTALLED/UPDATED.
            -- THIS IS ONLY RUN THEN, NOT EVERY TIME NEOVIM STARTS UP.
            build = 'make',

            -- `cond` IS A CONDITION USED TO DETERMINE WHETHER THIS PLUGIN SHOULD BE
            -- INSTALLED AND LOADED.
            cond = function()
                return vim.fn.executable 'make' == 1
            end,
        },
        { 'nvim-telescope/telescope-ui-select.nvim' },

        -- USEFUL FOR GETTING PRETTY ICONS, BUT REQUIRES A NERD FONT.
        { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()

        -- [[ CONFIGURE TELESCOPE ]]
        -- See `:help telescope` and `:help telescope.setup()`
        local telescope = require('telescope')
        local actions = require('telescope.actions')

        telescope.setup {
            defaults = {
                mappings = {
                    i = {
                        ['<C-k>'] = actions.move_selection_previous,
                        ['<C-j>'] = actions.move_selection_next,
                        ['<C-l>'] = actions.select_default,
                    },
                },
                prompt_prefix = "   ",
                selection_caret = "  ",
                entry_prefix = "  ",
                initial_mode = "insert",
                selection_strategy = "reset",
                sorting_strategy = "ascending",
                layout_strategy = "horizontal",
                layout_config = {
                    horizontal = {
                        prompt_position = "top",
                        preview_width = 0.55,
                        results_width = 0.8,
                    },
                    vertical = {
                        mirror = false,
                    },
                    width = 0.87,
                    height = 0.80,
                    preview_cutoff = 120,
                },
                border = true,
                borderchars = {
                    prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
                    results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
                    preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                },
                color_devicons = true,
                set_env = { ["COLORTERM"] = "truecolor" },
                file_previewer = require("telescope.previewers").vim_buffer_cat.new,
                grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
                qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
                buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                    "--hidden",
                },
            },
            pickers = {
                find_files = {
                    theme = "cursor",
                    previewer = false,
                    file_ignore_patterns = { 'node_modules', '.git', '.venv' },
                    hidden = true,
                    results_title = false,
                    prompt_title = false,
                    layout_strategy = "center",
                    layout_config = {
                        width = 0.6,
                        height = 0.6,
                    },
                },
                buffers = {
                    theme = "cursor",
                    previewer = false,
                    results_title = false,
                    prompt_title = false,
                    layout_config = {
                        width = 0.8,
                        height = 0.6,
                    },
                },
                help_tags = {
                    theme = "cursor",
                    results_title = false,
                    prompt_title = false,
                    layout_config = {
                        width = 0.8,
                        height = 0.6,
                    },
                },
                grep_string = {
                    theme = "cursor",
                    results_title = false,
                    prompt_title = false,
                    layout_config = {
                        width = 0.8,
                        height = 0.6,
                    },
                },
                live_grep = {
                    theme = "cursor",
                    results_title = false,
                    prompt_title = false,
                    layout_config = {
                        width = 0.8,
                        height = 0.6,
                    },
                },
            },
            extensions = {
                ['ui-select'] = {
                    require('telescope.themes').get_dropdown({
                        borderchars = {
                            { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                            prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
                            results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
                            preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                        },
                        width = 0.8,
                        previewer = false,
                        prompt_title = false,
                        results_title = false,
                    }),
                },
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
            },
        }

        -- ENABLE TELESCOPE EXTENSIONS IF THEY ARE INSTALLED
        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'ui-select')

        -- OVERRIDE TELESCOPE HIGHLIGHTS TO MATCH OUR COLOR SCHEME
        vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "#2a2a2a" })
        vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#9ca0a4", bg = "#2a2a2a" })
        vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "#2a2a2a" })
        vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = "#9ca0a4", bg = "#2a2a2a" })
        vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = "#9ca0a4", bg = "#2a2a2a" })
        vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = "#9ca0a4", bg = "#2a2a2a" })
        vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = "#9ca0a4", bg = "#2a2a2a" })
        vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = "#404040" })
        vim.api.nvim_set_hl(0, "TelescopePreviewLine", { bg = "#404040" })
        vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "#2a2a2a" })
        vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = "#9ca0a4", bg = "#2a2a2a" })

        -- KEYMAPS
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
        vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
        vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
        vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
        vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
        vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
        vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
        vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
        vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
        vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[S]earch [B]uffers' })

        -- SLIGHTLY ADVANCED EXAMPLE OF OVERRIDING DEFAULT BEHAVIOR AND THEME
        vim.keymap.set('n', '<leader>/', function()
            -- YOU CAN PASS ADDITIONAL CONFIGURATION TO TELESCOPE TO CHANGE THE THEME, LAYOUT, ETC.
            builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                previewer = false,
                theme = "dropdown",
            })
        end, { desc = '[/] Fuzzily search in current buffer' })

        -- IT'S ALSO POSSIBLE TO PASS ADDITIONAL CONFIGURATION OPTIONS.
        --  SEE `:help telescope.builtin.live_grep()` FOR INFORMATION ABOUT PARTICULAR KEYS
        vim.keymap.set('n', '<leader>s/', function()
            builtin.live_grep {
                grep_open_files = true,
                prompt_title = 'Live Grep in Open Files',
            }
        end, { desc = '[S]earch [/] in Open Files' })
    end,
}

return {
    'nvim-lualine/lualine.nvim',
    config = function()
        local colors = require('onedarkpro.helpers').get_colors()

        -- CUSTOM THEME --
        local custom_theme = {
            normal = {
                a = { fg = colors.fg, bg = colors.line, gui = 'bold' },
                b = { fg = colors.gray, bg = colors.bg },
                c = { fg = colors.comment, bg = colors.bg }
            },
            insert = {
                a = { fg = colors.fg, bg = colors.highlight, gui = 'bold' },
                b = { fg = colors.gray, bg = colors.bg }
            },
            visual = {
                a = { fg = colors.fg, bg = colors.selection, gui = 'bold' },
                b = { fg = colors.gray, bg = colors.bg }
            },
            replace = {
                a = { fg = colors.fg, bg = colors.line, gui = 'bold' },
                b = { fg = colors.gray, bg = colors.bg }
            },
            command = {
                a = { fg = colors.fg, bg = colors.highlight, gui = 'bold' },
                b = { fg = colors.gray, bg = colors.bg }
            },
            inactive = {
                a = { fg = colors.comment, bg = colors.bg },
                b = { fg = colors.comment, bg = colors.bg },
                c = { fg = colors.comment, bg = colors.bg }
            }
        }

        -- MODE --
        local mode = {
            'mode',
            fmt = function(str)
                return ' ' .. str
                -- return ' ' .. str:sub(1, 1) -- DISPLAYS ONLY THE FIRST CHARACTER OF THE MODE
            end,
        }

        -- FILENAME --
        local filename = {
            'filename',
            file_status = true, -- DISPLAYS FILE STATUS (READONLY STATUS, MODIFIED STATUS)
            path = 1, -- 0 = JUST FILENAME, 1 = RELATIVE PATH, 2 = ABSOLUTE PATH
        }

        -- HIDE IN WIDTH --
        local hide_in_width = function()
            return vim.fn.winwidth(0) > 100
        end

        -- DIAGNOSTICS --
        local diagnostics = {
            'diagnostics',
            sources = { 'nvim_diagnostic' },
            sections = { 'error', 'warn' },
            symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
            colored = false,
            update_in_insert = false,
            always_visible = false,
            cond = hide_in_width,
        }

        -- DIFF --
        local diff = {
            'diff',
            colored = false,
            symbols = { added = ' ', modified = ' ', removed = ' ' }, -- CHANGE DIFF SYMBOLS
            cond = hide_in_width,
        }

        -- SETUP --
        require('lualine').setup {
            options = {
                icons_enabled = true,
                theme = custom_theme,
                -- Some useful glyphs:
                -- https://www.nerdfonts.com/cheat-sheet
                --
                section_separators = { left = '', right = '' },
                component_separators = { left = '', right = '' },
                disabled_filetypes = { 'alpha', 'neo-tree' },
                always_divide_middle = true,
                globalstatus = true, -- MAKE LUALINE GLOBAL TO AVOID BEING CUT BY NEO-TREE
            },
            sections = {
                lualine_a = { mode },
                lualine_b = { 'branch' },
                lualine_c = { filename },
                lualine_x = { diagnostics, diff, { 'filetype', cond = hide_in_width } },
                lualine_y = { 'location' },
                lualine_z = { 'progress' },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { { 'filename', path = 1 } },
                lualine_x = { { 'location', padding = 0 } },
                lualine_y = {},
                lualine_z = {},
            },
            tabline = {},
            extensions = { 'fugitive' },
        }
    end,
}

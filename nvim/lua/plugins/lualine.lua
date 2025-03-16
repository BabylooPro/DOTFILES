return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        -- GET SYSTEM APPEARANCE
        local function get_system_appearance()
            local handle = io.popen [[osascript -e 'tell application "System Events" to tell appearance preferences to return dark mode']]
            if not handle then
                return false
            end
            local result = handle:read '*a'
            handle:close()
            return result:match 'true' ~= nil
        end

        -- GET THEME COLORS
        local function get_custom_theme()
            local colors = require('onedarkpro.helpers').get_colors()

            return {
                normal = {
                    a = { fg = colors.fg, bg = colors.line, gui = 'bold' },
                    b = { fg = colors.gray, bg = colors.bg },
                    c = { fg = colors.comment, bg = colors.bg },
                },
                insert = {
                    a = { fg = colors.fg, bg = colors.line, gui = 'bold' },
                    b = { fg = colors.gray, bg = colors.bg },
                },
                visual = {
                    a = { fg = colors.fg, bg = colors.selection, gui = 'bold' },
                    b = { fg = colors.gray, bg = colors.bg },
                },
                replace = {
                    a = { fg = colors.fg, bg = colors.line, gui = 'bold' },
                    b = { fg = colors.gray, bg = colors.bg },
                },
                command = {
                    a = { fg = colors.fg, bg = colors.line, gui = 'bold' },
                    b = { fg = colors.gray, bg = colors.bg },
                },
                inactive = {
                    a = { fg = colors.comment, bg = colors.bg },
                    b = { fg = colors.comment, bg = colors.bg },
                    c = { fg = colors.comment, bg = colors.bg },
                },
            }
        end

        -- MODE --
        local mode = {
            'mode',
            fmt = function(str)
                return ' ' .. str
            end,
        }

        -- FILENAME --
        local filename = {
            'filename',
            file_status = true,
            path = 1,
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
            symbols = { added = ' ', modified = ' ', removed = ' ' },
            cond = hide_in_width,
        }

        -- SETUP LUALINE
        local lualine = require 'lualine'
        lualine.setup {
            options = {
                icons_enabled = true,
                theme = get_custom_theme(),
                section_separators = { left = '', right = '' },
                component_separators = { left = '', right = '' },
                disabled_filetypes = { 'alpha', 'neo-tree' },
                always_divide_middle = true,
                globalstatus = true,
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

        -- UPDATE THEME ON SYSTEM CHANGES
        local timer = vim.loop.new_timer()
        timer:start(
            1000,
            5000,
            vim.schedule_wrap(function()
                lualine.setup {
                    options = {
                        icons_enabled = true,
                        theme = get_custom_theme(),
                        section_separators = { left = '', right = '' },
                        component_separators = { left = '', right = '' },
                        disabled_filetypes = { 'alpha', 'neo-tree' },
                        always_divide_middle = true,
                        globalstatus = true,
                    },
                }
            end)
        )
    end,
}

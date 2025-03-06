return {
    'akinsho/bufferline.nvim',
    dependencies = {
        'moll/vim-bbye',
        'nvim-tree/nvim-web-devicons',
    },
    config = function()
        local bufferline = require 'bufferline'
        local update_timer = nil
        local last_background = vim.o.background

        -- GET THEME COLORS
        local function get_theme_colors()
            local is_dark = vim.o.background == 'dark'
            -- GET BACKGROUND FROM CURRENT THEME
            local normal_hl = vim.api.nvim_get_hl(0, { name = 'Normal' })
            local bg = normal_hl.bg and string.format('#%06x', normal_hl.bg) or (is_dark and '#282c34' or '#fafafa')

            return {
                bg = bg,
                fg = is_dark and '#D4D4D4' or '#383A42',
                gray = is_dark and '#808080' or '#909090',
                selected_bg = is_dark and '#303030' or '#FFFFFF',
                selected_fg = is_dark and '#FFFFFF' or '#000000',
                separator = is_dark and '#252525' or '#EFEFEF',
                modified = is_dark and '#FF6C6B' or '#FF6B6B',
            }
        end

        -- APPLY HIGHLIGHTS DIRECTLY
        local function apply_highlights()
            local colors = get_theme_colors()
            local highlights = {
                -- NORMAL ELEMENTS
                BufferLineFill = { bg = colors.bg },
                BufferLineBackground = { bg = colors.bg, fg = colors.gray, italic = true },
                BufferLineBufferVisible = { bg = colors.bg, fg = colors.gray, italic = true },
                BufferLineTab = { bg = colors.bg, fg = colors.gray, italic = true },
                BufferLineTabClose = { bg = colors.bg, fg = colors.gray },
                BufferLineCloseButton = { bg = colors.bg, fg = colors.gray },
                BufferLineCloseButtonVisible = { bg = colors.bg, fg = colors.gray },
                BufferLineModified = { bg = colors.bg, fg = colors.modified },
                BufferLineModifiedVisible = { bg = colors.bg, fg = colors.modified },
                BufferLineSeparator = { fg = colors.separator, bg = colors.bg },
                BufferLineSeparatorVisible = { fg = colors.separator, bg = colors.bg },
                BufferLineDuplicate = { bg = colors.bg, fg = colors.gray, italic = true },
                BufferLineDuplicateVisible = { bg = colors.bg, fg = colors.gray, italic = true },

                -- DEVICONS NORMAL
                BufferLineDevIconDefault = { bg = colors.bg },
                BufferLineDevIconDefaultInactive = { bg = colors.bg },
                BufferLineDevIconDefaultVisible = { bg = colors.bg },
                BufferLineDevIconLua = { bg = colors.bg },
                BufferLineDevIconLuaInactive = { bg = colors.bg },
                BufferLineDevIconLuaVisible = { bg = colors.bg },
                BufferLineDevIconMarkdown = { bg = colors.bg },
                BufferLineDevIconMarkdownInactive = { bg = colors.bg },
                BufferLineDevIconMarkdownVisible = { bg = colors.bg },

                -- SELECTED ELEMENTS
                BufferLineBufferSelected = { bg = colors.selected_bg, fg = colors.selected_fg, bold = false, italic = false },
                BufferLineTabSelected = { bg = colors.selected_bg, fg = colors.selected_fg, bold = false, italic = false },
                BufferLineCloseButtonSelected = { bg = colors.selected_bg, fg = colors.selected_fg },
                BufferLineSeparatorSelected = { fg = colors.separator, bg = colors.selected_bg },
                BufferLineModifiedSelected = { bg = colors.selected_bg, fg = colors.modified },
                BufferLineIndicatorSelected = { fg = colors.selected_bg, bg = colors.selected_bg },
                BufferLineDuplicateSelected = { bg = colors.selected_bg, fg = colors.selected_fg, italic = false },

                -- DEVICONS SELECTED
                BufferLineDevIconDefaultSelected = { bg = colors.selected_bg },
                BufferLineDevIconLuaSelected = { bg = colors.selected_bg },
                BufferLineDevIconMarkdownSelected = { bg = colors.selected_bg },
                BufferLineDevIconSelectedSelected = { bg = colors.selected_bg },
            }

            -- APPLY ALL HIGHLIGHTS
            for group, opts in pairs(highlights) do
                vim.api.nvim_set_hl(0, group, opts)
            end

            -- APPLY HIGHLIGHTS FOR ALL FILETYPES
            local devicons = require 'nvim-web-devicons'
            local icons = devicons.get_icons()
            for _, icon in pairs(icons) do
                local hl_group = 'BufferLineDevIcon' .. icon.name
                vim.api.nvim_set_hl(0, hl_group, { bg = colors.bg })
                vim.api.nvim_set_hl(0, hl_group .. 'Selected', { bg = colors.selected_bg })
                vim.api.nvim_set_hl(0, hl_group .. 'Visible', { bg = colors.bg })
                vim.api.nvim_set_hl(0, hl_group .. 'Inactive', { bg = colors.bg })
            end
        end

        -- DEBOUNCED UPDATE FUNCTION
        local function debounced_update()
            if update_timer then
                update_timer:stop()
                update_timer:close()
            end

            update_timer = vim.loop.new_timer()
            update_timer:start(
                150,
                0,
                vim.schedule_wrap(function()
                    last_background = vim.o.background
                    apply_highlights()
                    update_timer:stop()
                    update_timer:close()
                    update_timer = nil
                end)
            )
        end

        -- FORCE UPDATE IMMEDIATELY
        local function force_update()
            if update_timer then
                update_timer:stop()
                update_timer:close()
                update_timer = nil
            end
            vim.schedule(function()
                last_background = vim.o.background
                apply_highlights()
            end)
        end

        -- SETUP BUFFERLINE
        local function setup_bufferline()
            bufferline.setup {
                options = {
                    mode = 'buffers',
                    numbers = 'none',
                    close_command = 'Bdelete! %d',
                    right_mouse_command = 'Bdelete! %d',
                    buffer_close_icon = '✗',
                    close_icon = '✗',
                    hover = {
                        enabled = true,
                        delay = 200,
                        reveal = { 'close' },
                    },
                    modified_icon = '●',
                    left_trunc_marker = '',
                    right_trunc_marker = '',
                    custom_filter = function(buf_number)
                        return vim.api.nvim_buf_get_name(buf_number) ~= ''
                    end,
                    offsets = {
                        {
                            filetype = 'neo-tree',
                            text = function()
                                return string.upper(vim.fn.fnamemodify(vim.fn.getcwd(), ':t'))
                            end,
                            text_align = 'center',
                            separator = false,
                        },
                    },
                    max_name_length = 30,
                    max_prefix_length = 30,
                    tab_size = 21,
                    diagnostics = false,
                    show_buffer_icons = true,
                    show_buffer_close_icons = true,
                    show_close_icon = false,
                    separator_style = { ' ', ' ' },
                    enforce_regular_tabs = false,
                    always_show_bufferline = true,
                    indicator = { style = 'none' },
                    themable = true,
                },
            }

            -- APPLY HIGHLIGHTS IMMEDIATELY
            force_update()
        end

        -- INITIAL SETUP
        setup_bufferline()

        -- UPDATE ON COLORSCHEME CHANGE
        vim.api.nvim_create_autocmd('ColorScheme', {
            callback = force_update,
            group = vim.api.nvim_create_augroup('BufferlineColorscheme', { clear = true }),
        })

        -- FORCE UPDATE ON BACKGROUND CHANGE
        vim.api.nvim_create_autocmd('OptionSet', {
            pattern = 'background',
            callback = force_update,
            group = vim.api.nvim_create_augroup('BufferlineBackground', { clear = true }),
        })
    end,
}

return {
    'akinsho/bufferline.nvim',
    dependencies = {
        'moll/vim-bbye',
        'nvim-tree/nvim-web-devicons',
    },
    config = function()
        local bufferline = require 'bufferline'

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
                custom_filter = function(buf_number, buf_numbers)
                    -- FILTER OUT "NO NAME" BUFFERS
                    local has_name = vim.api.nvim_buf_get_name(buf_number) ~= ""
                    if not has_name then
                        return false
                    end
                    return true
                end,
                offsets = {
                    {
                        filetype = 'neo-tree',
                        text = function()
                            -- GET PROJECT DIRECTORY NAME
                            local cwd = vim.fn.getcwd()
                            local dir_name = vim.fn.fnamemodify(cwd, ':t')
                            return string.upper(dir_name)
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
                indicator = {
                    style = 'none',
                },
                themable = true,
                custom_areas = {
                    right = function()
                        local result = {}
                        local seve = vim.diagnostic.severity
                        local error = #vim.diagnostic.get(0, { severity = seve.ERROR })
                        local warning = #vim.diagnostic.get(0, { severity = seve.WARN })
                        local info = #vim.diagnostic.get(0, { severity = seve.INFO })
                        local hint = #vim.diagnostic.get(0, { severity = seve.HINT })

                        if error ~= 0 then
                            table.insert(result, { text = '  ' .. error, link = 'DiagnosticError' })
                        end

                        if warning ~= 0 then
                            table.insert(result, { text = '  ' .. warning, link = 'DiagnosticWarn' })
                        end

                        if hint ~= 0 then
                            table.insert(result, { text = '  ' .. hint, link = 'DiagnosticHint' })
                        end

                        if info ~= 0 then
                            table.insert(result, { text = '  ' .. info, link = 'DiagnosticInfo' })
                        end
                        return result
                    end,
                },
            },
            highlights = {
                -- NORMAL ELEMENTS
                fill = { bg = '#202020' },
                background = { bg = '#202020', fg = '#9A9A9A', italic = true },
                buffer_visible = { bg = '#202020', fg = '#9A9A9A', italic = true },
                tab = { bg = '#202020', fg = '#9A9A9A', italic = true },
                tab_close = { bg = '#202020', fg = '#9A9A9A' },
                close_button = { bg = '#202020', fg = '#9A9A9A' },
                close_button_visible = { bg = '#202020', fg = '#9A9A9A' },
                modified = { bg = '#202020', fg = '#FF6C6B' },
                modified_visible = { bg = '#202020', fg = '#FF6C6B' },
                separator = { fg = '#303030', bg = '#202020' },
                separator_visible = { fg = '#303030', bg = '#202020' },
                duplicate = { bg = '#202020', fg = '#9A9A9A', italic = true },
                duplicate_visible = { bg = '#202020', fg = '#9A9A9A', italic = true },

                -- SELECTED ELEMENTS (ACTIVE TAB)
                buffer_selected = { bg = '#404040', fg = '#FFFFFF', bold = false, italic = false },
                tab_selected = { bg = '#404040', fg = '#FFFFFF', bold = false, italic = false },
                close_button_selected = { bg = '#404040', fg = '#FFFFFF' },
                separator_selected = { fg = '#303030', bg = '#404040' },
                modified_selected = { bg = '#404040', fg = '#FF6C6B' },
                indicator_selected = { fg = '#404040', bg = '#404040' },
                duplicate_selected = { bg = '#404040', fg = '#FFFFFF', italic = false },
            },
        }

        -- SET ESSENTIAL HIGHLIGHTS & REGULAR TAB HIGHLIGHTS
        vim.api.nvim_set_hl(0, 'BufferLineBufferSelected', { bg = '#404040', fg = '#FFFFFF', bold = false, italic = false })
        vim.api.nvim_set_hl(0, 'BufferLineSeparatorSelected', { bg = '#404040', fg = '#303030' })
        vim.api.nvim_set_hl(0, 'BufferLineCloseButtonSelected', { bg = '#404040', fg = '#FFFFFF' })
        vim.api.nvim_set_hl(0, 'BufferLineModifiedSelected', { bg = '#404040', fg = '#FF6C6B' })
        vim.api.nvim_set_hl(0, 'BufferLineTabSelected', { bg = '#404040', fg = '#FFFFFF', bold = false, italic = false })

        vim.api.nvim_create_autocmd('ColorScheme', {
            callback = function()
                vim.api.nvim_set_hl(0, 'BufferLineBufferSelected', { bg = '#404040', fg = '#FFFFFF' })
            end,
        })

        -- APPLY HIGHLIGHTS AGAIN WHEN COLORSHEME CHANGES
        vim.api.nvim_create_autocmd('ColorScheme', {
            callback = function()
                -- REGULAR TAB HIGHLIGHTS
                vim.api.nvim_set_hl(0, 'BufferLineBufferSelected', { bg = '#404040', fg = '#FFFFFF', bold = false, italic = false })
                vim.api.nvim_set_hl(0, 'BufferLineSeparatorSelected', { bg = '#404040', fg = '#303030' })
                vim.api.nvim_set_hl(0, 'BufferLineCloseButtonSelected', { bg = '#404040', fg = '#FFFFFF' })
                vim.api.nvim_set_hl(0, 'BufferLineModifiedSelected', { bg = '#404040', fg = '#FF6C6B' })
                vim.api.nvim_set_hl(0, 'BufferLineTabSelected', { bg = '#404040', fg = '#FFFFFF', bold = false, italic = false })
            end,
        })
    end,
}

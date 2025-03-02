return {
    'olimorris/onedarkpro.nvim',
    lazy = false,
    priority = 1000,
    config = function()
        require('onedarkpro').setup {
            colors = {
                bg = '#202020',
                fg = '#D4D4D4',
                red = '#FF6C6B',
                line = '#252525',
                selection = '#4E4E4E',
                highlight = '#3E3E3E',
                comment = '#767676',
                gray = '#9A9A9A',
                purple = '#C678DD',
                blue = '#61AFEF',
                yellow = '#E5C07B',
                green = '#98C379',
            },

            styles = {
                types = 'NONE',
                methods = 'NONE',
                numbers = 'NONE',
                strings = 'NONE',
                comments = 'italic',
                keywords = 'bold,italic',
                constants = 'bold',
                functions = 'italic',
                operators = 'NONE',
                variables = 'NONE',
                parameters = 'NONE',
                conditionals = 'italic',
                virtual_text = 'NONE',
            },

            options = {
                bold = true,
                italic = true,
                underline = true,
                undercurl = true,
                cursorline = false,
                transparency = false,
                terminal_colors = true,
                highlight_inactive_windows = false,
            },
            
            highlights = {
                -- INTERFACE HIGHLIGHTS --
                Normal = { bg = '#202020', fg = '#D4D4D4' },
                NormalFloat = { bg = '#252525' },
                LineNr = { fg = '#919191' },
                CursorLine = { bg = '#252525' },
                CursorLineNr = { fg = '#ffffff' },
                Visual = { bg = '#4E4E4E' },
                Search = { bg = '#7E7E7E' },
                IncSearch = { bg = '#5E5E5E' },
                VertSplit = { fg = '#202020', bg = '#202020' },
                StatusLine = { bg = '#202020', fg = '#FFFFFF' },
                StatusLineNC = { bg = '#202020', fg = '#9A9A9A' },

                -- EDITOR HIGHLIGHTS --
                Cursor = { fg = '#C7C7C7' },
                ColorColumn = { bg = '#252525' },
                SignColumn = { bg = '#202020' },
                Whitespace = { fg = '#5C5C5C' },
                IndentBlankline = { fg = '#353535' },

                -- POPUP AND COMPLETION MENU --
                Pmenu = { bg = '#202020', fg = '#D4D4D4' },
                PmenuSel = { bg = '#3E3E3E', fg = '#D4D4D4' },
                PmenuSbar = { bg = '#303030' },
                PmenuThumb = { bg = '#5C5C5C' },

                -- BRACKET MATCHING --
                MatchParen = { bg = '#3E3E3E', fg = '#C7C7C7' },

                -- TAB BAR --
                TabLine = { bg = '#202020', fg = '#9A9A9A' },
                TabLineSel = { bg = '#202020', fg = '#C7C7C7' },
                TabLineFill = { bg = '#202020' },

                -- BUFFERLINE --
                BufferLineFill = { bg = '#202020' },
                BufferLineBackground = { bg = '#202020', fg = '#9A9A9A' },
                BufferLineBufferSelected = { bg = '#202020', fg = '#C7C7C7' },
                BufferLineBufferVisible = { bg = '#202020', fg = '#9A9A9A' },
                BufferLineTab = { bg = '#202020', fg = '#9A9A9A' },
                BufferLineTabSelected = { bg = '#202020', fg = '#C7C7C7' },
                BufferLineTabClose = { bg = '#202020', fg = '#9A9A9A' },
                BufferLineIndicatorSelected = { bg = '#202020', fg = '#202020' },
                BufferLineSeparator = { bg = '#202020', fg = '#202020' },
                BufferLineSeparatorSelected = { bg = '#202020', fg = '#202020' },

                -- DIAGNOSTICS --
                DiagnosticError = { fg = '#C72E2E' },
                DiagnosticWarn = { fg = '#C78E2E' },
                DiagnosticInfo = { fg = '#2E97C7' },
                DiagnosticHint = { fg = '#9A9A9A' },

                -- NEOVIM TERMINAL --
                Terminal = { bg = '#202020', fg = '#D4D4D4' },

                -- SIDEBAR --
                NvimTreeNormal = { bg = '#202020', fg = '#FFFFFF' },
                NvimTreeEndOfBuffer = { bg = '#202020', fg = '#202020' },
                NvimTreeIndentMarker = { fg = '#353535' },

                -- GIT HIGHLIGHTS --
                GitSignsAdd = { fg = '#98C379' },
                GitSignsChange = { fg = '#61AFEF' },
                GitSignsDelete = { fg = '#FF6C6B' },

                -- TELESCOPE --
                TelescopeNormal = { bg = '#202020' },
                TelescopeBorder = { bg = '#202020', fg = '#202020' },
                TelescopePromptNormal = { bg = '#252525' },
                TelescopePromptBorder = { bg = '#252525', fg = '#252525' },
                TelescopePromptTitle = { bg = '#FF6C6B', fg = '#FFFFFF' },
                TelescopeResultsNormal = { bg = '#202020' },
                TelescopeResultsBorder = { bg = '#202020', fg = '#202020' },
                TelescopeResultsTitle = { bg = '#FF6C6B', fg = '#FFFFFF' },
                TelescopeSelectionCaret = { fg = '#FF6C6B' },
                TelescopeSelection = { bg = '#383B41' },

                -- COMMENTS --
                Comment = { fg = '#767676', style = 'italic' },

                -- LSP --
                LspReferenceText = { bg = '#3E3E3E' },
                LspReferenceRead = { bg = '#3E3E3E' },
                LspReferenceWrite = { bg = '#3E3E3E' },
            },
        }

        vim.cmd [[colorscheme onedark]]

        -- TOGGLE BACKGROUND TRANSPARENCY
        local bg_transparent = false

        -- TOGGLE BACKGROUND TRANSPARENCY
        local toggle_transparency = function()
            bg_transparent = not bg_transparent
            require('onedarkpro').setup {
                options = {
                    transparency = bg_transparent,
                },
            }
            vim.cmd [[colorscheme onedark]]
        end

        -- APPLY HIGHLIGHTS AGAIN WHEN COLORSHEME CHANGES
        vim.defer_fn(function()
            vim.api.nvim_set_hl(0, 'BufferLineFill', { bg = '#202020' })
            vim.api.nvim_set_hl(0, 'BufferLineBufferSelected', { bg = '#404040', fg = '#FFFFFF' })
            vim.api.nvim_set_hl(0, 'BufferLineDiagnosticSelected', { fg = '#FFFFFF', bg = '#404040' })
        end, 50)

        vim.keymap.set('n', '<leader>bg', toggle_transparency, { noremap = true, silent = true })
    end,
}

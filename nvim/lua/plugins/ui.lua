return {
    {
        -- NOICE: A CUSTOMIZABLE AND AESTHETIC NOTIFICATION PLUGIN FOR NEOVIM
        'folke/noice.nvim',
        event = 'VeryLazy',
        dependencies = {
            'MunifTanjim/nui.nvim',
            'rcarriga/nvim-notify',
        },
        opts = {
            cmdline = {
                enabled = true,
                view = 'cmdline_popup',
                opts = {
                    border = {
                        style = 'rounded',
                        padding = { 0, 1 },
                    },
                    win_options = {
                        winhighlight = {
                            Normal = 'NormalFloat',
                            FloatBorder = 'FloatBorder',
                        },
                    },
                },
            },
            messages = {
                enabled = true,
                view = 'notify',
                view_error = 'notify',
                view_warn = 'notify',
                view_history = 'messages',
                view_search = 'virtualtext',
            },
            popupmenu = {
                enabled = true,
                backend = 'nui',
                kind_icons = {},
            },
            notify = {
                enabled = true,
                view = 'notify',
                opts = {
                    background_colour = '#2a2a2a',
                },
            },
            lsp = {
                progress = {
                    enabled = false,
                    format = 'lsp_progress',
                    format_done = 'lsp_progress_done',
                    throttle = 1000 / 30,
                    view = 'mini',
                },
                override = {
                    ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                    ['vim.lsp.util.stylize_markdown'] = true,
                    ['cmp.entry.get_documentation'] = true,
                },
                hover = {
                    enabled = true,
                    silent = false,
                    view = nil,
                    opts = {
                        border = {
                            style = 'rounded',
                            padding = { 0, 1 },
                        },
                        win_options = {
                            winhighlight = {
                                Normal = 'NormalFloat',
                                FloatBorder = 'FloatBorder',
                            },
                        },
                    },
                },
                signature = {
                    enabled = true,
                    auto_open = {
                        enabled = true,
                        trigger = true,
                        luasnip = true,
                        throttle = 50,
                    },
                    view = nil,
                    opts = {
                        border = {
                            style = 'rounded',
                            padding = { 0, 1 },
                        },
                        win_options = {
                            winhighlight = {
                                Normal = 'NormalFloat',
                                FloatBorder = 'FloatBorder',
                            },
                        },
                    },
                },
                message = {
                    enabled = true,
                    view = 'notify',
                    opts = {},
                },
                documentation = {
                    view = 'hover',
                    opts = {
                        lang = 'markdown',
                        replace = true,
                        render = 'plain',
                        format = { '{message}' },
                        win_options = {
                            concealcursor = 'n',
                            conceallevel = 3,
                            winhighlight = {
                                Normal = 'NormalFloat',
                                FloatBorder = 'FloatBorder',
                            },
                        },
                        border = {
                            style = 'rounded',
                            padding = { 0, 1 },
                        },
                    },
                },
            },
            views = {
                cmdline_popup = {
                    position = {
                        row = '50%',
                        col = '50%',
                    },
                    size = {
                        width = 60,
                        height = 'auto',
                    },
                    border = {
                        style = 'rounded',
                        padding = { 0, 1 },
                    },
                    win_options = {
                        winhighlight = {
                            Normal = 'NormalFloat',
                            FloatBorder = 'FloatBorder',
                        },
                    },
                },
                popupmenu = {
                    relative = 'editor',
                    position = {
                        row = 8,
                        col = '50%',
                    },
                    size = {
                        width = 60,
                        height = 10,
                    },
                    border = {
                        style = 'rounded',
                        padding = { 0, 1 },
                    },
                    win_options = {
                        winhighlight = {
                            Normal = 'NormalFloat',
                            FloatBorder = 'FloatBorder',
                            CursorLine = 'PmenuSel',
                        },
                    },
                },
            },
            routes = {
                {
                    filter = {
                        event = 'msg_show',
                        kind = '',
                        find = 'written',
                    },
                    opts = { skip = true },
                },
            },
        },
    },
    {
        -- NOTIFICATIONS FOR NEOVIM
        'rcarriga/nvim-notify',
        opts = {
            background_colour = '#2a2a2a',
            timeout = 3000,
            max_height = function()
                return math.floor(vim.o.lines * 0.75)
            end,
            max_width = function()
                return math.floor(vim.o.columns * 0.75)
            end,
            render = 'default',
            stages = 'fade',
            top_down = true,
        },
    },
    {
        -- SCROLLBAR FOR NEOVIM
        'petertriho/nvim-scrollbar',
        event = 'VeryLazy',
        config = function()
            local scrollbar = require 'scrollbar'

            -- SIMPLE CONFIGURATION
            scrollbar.setup {
                show = true,
                show_in_active_only = false,
                set_highlights = true,
                folds = 1000, -- handle folds, set to number to disable folds if no. of lines in buffer exceeds this
                max_lines = false, -- disables if no. of lines in buffer exceeds this
                hide_if_all_visible = false, -- Hides everything if all lines are visible
                throttle_ms = 100,
                handle = {
                    text = ' ',
                    blend = 30, -- Integer between 0 and 100. 0 for fully opaque and 100 to full transparent. Defaults to 30.
                    color = nil,
                    color_nr = nil, -- cterm
                    highlight = 'CursorColumn',
                    hide_if_all_visible = true, -- Hides handle if all lines are visible
                },
                marks = {
                    Cursor = {
                        text = '•',
                        priority = 0,
                        gui = nil,
                        color = nil,
                        cterm = nil,
                        color_nr = nil, -- cterm
                        highlight = 'Normal',
                    },
                    Search = {
                        text = { '-', '=' },
                        priority = 1,
                        gui = nil,
                        color = nil,
                        cterm = nil,
                        color_nr = nil, -- cterm
                        highlight = 'Search',
                    },
                    Error = {
                        text = { '-', '=' },
                        priority = 2,
                        gui = nil,
                        color = nil,
                        cterm = nil,
                        color_nr = nil, -- cterm
                        highlight = 'DiagnosticVirtualTextError',
                    },
                    Warn = {
                        text = { '-', '=' },
                        priority = 3,
                        gui = nil,
                        color = nil,
                        cterm = nil,
                        color_nr = nil, -- cterm
                        highlight = 'DiagnosticVirtualTextWarn',
                    },
                    Info = {
                        text = { '-', '=' },
                        priority = 4,
                        gui = nil,
                        color = nil,
                        cterm = nil,
                        color_nr = nil, -- cterm
                        highlight = 'DiagnosticVirtualTextInfo',
                    },
                    Hint = {
                        text = { '-', '=' },
                        priority = 5,
                        gui = nil,
                        color = nil,
                        cterm = nil,
                        color_nr = nil, -- cterm
                        highlight = 'DiagnosticVirtualTextHint',
                    },
                    Misc = {
                        text = { '-', '=' },
                        priority = 6,
                        gui = nil,
                        color = nil,
                        cterm = nil,
                        color_nr = nil, -- cterm
                        highlight = 'Normal',
                    },
                    GitAdd = {
                        text = '┆',
                        priority = 7,
                        gui = nil,
                        color = nil,
                        cterm = nil,
                        color_nr = nil, -- cterm
                        highlight = 'GitSignsAdd',
                    },
                    GitChange = {
                        text = '┆',
                        priority = 7,
                        gui = nil,
                        color = nil,
                        cterm = nil,
                        color_nr = nil, -- cterm
                        highlight = 'GitSignsChange',
                    },
                    GitDelete = {
                        text = '▁',
                        priority = 7,
                        gui = nil,
                        color = nil,
                        cterm = nil,
                        color_nr = nil, -- cterm
                        highlight = 'GitSignsDelete',
                    },
                },
                excluded_buftypes = {
                    'terminal',
                },
                excluded_filetypes = {
                    'dropbar_menu',
                    'dropbar_menu_fzf',
                    'DressingInput',
                    'cmp_docs',
                    'cmp_menu',
                    'noice',
                    'prompt',
                    'TelescopePrompt',
                },
                autocmd = {
                    render = {
                        'BufWinEnter',
                        'TabEnter',
                        'TermEnter',
                        'WinEnter',
                        'CmdwinLeave',
                        'TextChanged',
                        'VimResized',
                        'WinScrolled',
                    },
                    clear = {
                        'BufWinLeave',
                        'TabLeave',
                        'TermLeave',
                        'WinLeave',
                    },
                },
                handlers = {
                    cursor = true,
                    diagnostic = true,
                    gitsigns = true, -- Requires gitsigns
                    handle = true,
                    search = false, -- Requires hlslens
                    ale = false, -- Requires ALE
                },
            }

            -- TIMER TO HIDE SCROLLBAR AFTER 2 SECONDS
            local timer = vim.loop.new_timer()
            local handle_visible = true

            local function hide_scrollbar_handle()
                handle_visible = false

                -- MODIFY CONFIGURATION TO DISABLE ONLY THE HANDLE
                local current_config = require('scrollbar.config').get()
                current_config.handlers.handle = false

                -- APPLY UPDATED CONFIGURATION
                scrollbar.setup(current_config)
            end

            -- FUNCTION TO SHOW SCROLLBAR
            local function show_scrollbar()
                if timer then
                    timer:stop()
                end

                -- REACTIVATE THE HANDLE IF IT WAS HIDDEN
                if not handle_visible then
                    handle_visible = true

                    -- REACTIVATE THE HANDLE
                    local current_config = require('scrollbar.config').get()
                    current_config.handlers.handle = true

                    -- APPLY UPDATED CONFIGURATION
                    scrollbar.setup(current_config)
                end

                timer:start(2000, 0, function()
                    vim.schedule(hide_scrollbar_handle)
                end)
            end

            -- REGISTER EVENTS THAT RE-DISPLAY SCROLLBAR
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'WinScrolled' }, {
                callback = show_scrollbar,
                pattern = '*',
            })

            -- HIDE SCROLLBAR HANDLE ON STARTUP THEN RE-DISPLAY AFTER INTERACTION
            vim.defer_fn(hide_scrollbar_handle, 1000)
        end,
    },
}

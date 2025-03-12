return {
    'chikko80/error-lens.nvim',
    event = 'BufRead',
    dependencies = {
        'nvim-telescope/telescope.nvim',
    },
    opts = {
        -- ERROR LENS CONFIGURATION
        enabled = true,
        auto_adjust = {
            enable = false,
        },
        prefix = 4, -- DISTANCE BETWEEN CODE AND MESSAGE
        -- CUSTOM COLORS ACCORDING TO PREFERENCES
        colors = {
            error_fg = '#ed6a5e', -- SOFT RED
            error_bg = '#2b2222', -- SUBTLE BACKGROUND FOR ERRORS
            warn_fg = '#f6be4f', -- AMBER/GOLD
            warn_bg = '#2b2922', -- LIGHT BACKGROUND FOR WARNINGS
            info_fg = '#5482C5', -- NEUTRAL BLUE
            info_bg = '#222529', -- LIGHT BACKGROUND FOR INFO
            hint_fg = '#404040', -- DARK GRAY
            hint_bg = '#252525', -- BARELY VISIBLE BACKGROUND
        },
    },
    config = function(_, opts)
        -- DIRECTLY PATCH THE HIGHLIGHT FUNCTION AT THE LOWEST LEVEL
        local path_highlight = package.loaded['error-lens.highlight'] or require 'error-lens.highlight'

        -- SAVE THE ORIGINAL FUNCTION
        local original_set_highlight = path_highlight.set_highlight

        -- REPLACE WITH A PROTECTED VERSION
        path_highlight.set_highlight = function(bufnr, lnum, col, end_col, hl_group, namespace)
            -- COMPLETE SAFETY CHECK
            if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
                return
            end

            -- IGNORE SPECIAL/TEMPORARY BUFFERS
            local buf_type = vim.bo[bufnr].buftype
            if buf_type ~= '' then
                return
            end

            -- CHECK THAT THE LINE EXISTS IN THE BUFFER
            local line_count = vim.api.nvim_buf_line_count(bufnr)
            if lnum >= line_count then
                return
            end

            -- IF ALL CHECKS PASS, USE THE ORIGINAL FUNCTION
            pcall(original_set_highlight, bufnr, lnum, col, end_col, hl_group, namespace)
        end

        -- ALSO PATCH THE UPDATE_HIGHLIGHTS FUNCTION
        local original_update = path_highlight.update_highlights
        path_highlight.update_highlights = function(...)
            pcall(original_update, ...)
        end

        -- CONFIGURE THE PLUGIN WITH OUR OPTIONS
        require('error-lens').setup(opts)

        -- PATCH THE GLOBAL DIAGNOSTIC HANDLER TO PROTECT THE ENTIRE FLOW
        local orig_diagnostic_handler = vim.diagnostic.handlers.virtual_text
        vim.diagnostic.handlers.virtual_text = {
            show = function(namespace, bufnr, diagnostics, opts)
                -- CHECK THE BUFFER
                if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
                    return
                end

                local buf_type = vim.bo[bufnr].buftype
                if buf_type ~= '' then
                    return
                end

                -- FILTER VALID DIAGNOSTICS
                local valid_diagnostics = {}
                local line_count = vim.api.nvim_buf_line_count(bufnr)

                for _, diagnostic in ipairs(diagnostics or {}) do
                    if diagnostic.lnum < line_count then
                        table.insert(valid_diagnostics, diagnostic)
                    end
                end

                -- CALL ORIGINAL HANDLER
                pcall(function()
                    orig_diagnostic_handler.show(namespace, bufnr, valid_diagnostics, opts)
                end)
            end,
            hide = function(namespace, bufnr)
                pcall(function()
                    orig_diagnostic_handler.hide(namespace, bufnr)
                end)
            end,
        }

        -- TEMPORARILY DISABLE ERRORLENS DURING TELESCOPE OPENING
        local telescope_module = require 'telescope'
        local orig_telescope = telescope_module.setup

        telescope_module.setup = function(opts)
            -- CONFIGURE TELESCOPE WITH ORIGINAL OPTIONS
            local result = orig_telescope(opts)

            -- ADD PRE/POST TELESCOPE HOOKS
            vim.api.nvim_create_autocmd('User', {
                pattern = 'TelescopePreviewerLoaded',
                callback = function()
                    -- DISABLE DIAGNOSTICS FOR TELESCOPE PREVIEWS
                    vim.api.nvim_create_autocmd('BufEnter', {
                        callback = function(ev)
                            local win_id = vim.api.nvim_get_current_win()
                            local win_config = vim.api.nvim_win_get_config(win_id)
                            if win_config.relative ~= '' then
                                -- THIS IS A FLOATING WINDOW, DISABLE ERRORLENS
                                vim.diagnostic.disable(ev.buf)
                            end
                        end,
                        group = vim.api.nvim_create_augroup('ErrorLensTelescope', { clear = true }),
                    })
                end,
            })

            return result
        end

        -- COMMAND TO ENABLE/DISABLE THE PLUGIN
        vim.api.nvim_create_user_command('ErrorLensToggle', function()
            pcall(function()
                if vim.g.error_lens_enabled == nil then
                    vim.g.error_lens_enabled = true
                end

                vim.g.error_lens_enabled = not vim.g.error_lens_enabled

                if vim.g.error_lens_enabled then
                    vim.notify 'ErrorLens enabled'
                else
                    vim.notify 'ErrorLens disabled'
                    -- CLEAN UP EXISTING HIGHLIGHTS
                    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                        if vim.api.nvim_buf_is_valid(bufnr) then
                            vim.api.nvim_buf_clear_namespace(bufnr, vim.api.nvim_create_namespace 'error_lens_namespace', 0, -1)
                        end
                    end
                end
            end)
        end, {})

        -- SHORTCUT TO ENABLE/DISABLE
        vim.keymap.set('n', '<leader>el', function()
            vim.cmd 'ErrorLensToggle'
        end, { desc = 'Toggle ErrorLens' })
    end,
}

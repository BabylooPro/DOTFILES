return {
    'kevinhwang91/nvim-bqf',
    dependencies = {
        'neovim/nvim-lspconfig',
    },

    config = function()
        -- CONFIGURE DIAGNOSTIC DISPLAY
        vim.diagnostic.config {
            virtual_text = {
                source = false,
                format = function(diagnostic)
                    return diagnostic.message
                end,
                spacing = 2,
                prefix = '',
            },
            signs = true,
            underline = true,
            update_in_insert = true,
            severity_sort = true,
            float = {
                focusable = false,
                style = 'minimal',
                border = 'rounded',
                source = 'always',
                header = '',
                prefix = '',
            },
        }

        -- SET DIAGNOSTIC SIGNS
        local signs = {
            Error = '',
            Warn = '',
            Hint = '',
            Info = '',
        }
        for type, icon in pairs(signs) do
            local hl = 'DiagnosticSign' .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end

        -- SET DIAGNOSTIC COLORS WITH FULL LINE HIGHLIGHTING
        vim.cmd [[
            highlight DiagnosticVirtualTextError guibg=#4B252C guifg=#FF6363
            highlight DiagnosticVirtualTextWarn guibg=#403733 guifg=#FA973A
            highlight DiagnosticVirtualTextInfo guibg=#281478 guifg=#5B38E8
            highlight DiagnosticVirtualTextHint guibg=#147828 guifg=#25E64B
            
            " Highlight the whole line
            highlight DiagnosticLineError guibg=#4B252C
            highlight DiagnosticLineWarn guibg=#403733
            highlight DiagnosticLineInfo guibg=#281478
            highlight DiagnosticLineHint guibg=#147828
        ]]

        -- CREATE AUTOCOMMANDS TO HIGHLIGHT THE WHOLE LINE
        local diagnostic_ns = vim.api.nvim_create_namespace 'diagnostic_highlighting'
        vim.api.nvim_create_autocmd({ 'DiagnosticChanged', 'InsertEnter', 'InsertChange', 'TextChangedI' }, {
            callback = function()
                vim.api.nvim_buf_clear_namespace(0, diagnostic_ns, 0, -1)
                local diagnostics = vim.diagnostic.get(0)
                for _, d in ipairs(diagnostics) do
                    local higroup = 'DiagnosticLine' .. ({ [1] = 'Error', [2] = 'Warn', [3] = 'Info', [4] = 'Hint' })[d.severity]
                    vim.api.nvim_buf_add_highlight(0, diagnostic_ns, higroup, d.lnum, 0, -1)
                end
            end,
        })
    end,
}

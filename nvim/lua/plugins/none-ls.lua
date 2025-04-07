return {
    'nvimtools/none-ls.nvim',
    dependencies = {
        'nvimtools/none-ls-extras.nvim',
        'jayp0521/mason-null-ls.nvim', -- ensure dependencies are installed
    },
    config = function()
        local null_ls = require 'null-ls'
        local formatting = null_ls.builtins.formatting -- to setup formatters
        local diagnostics = null_ls.builtins.diagnostics -- to setup linters

        -- Formatters & linters for mason to install
        require('mason-null-ls').setup {
            ensure_installed = {
                'prettier', -- ts/js formatter
                'stylua', -- lua formatter
                'eslint_d', -- ts/js linter
                'shfmt', -- Shell formatter
                'checkmake', -- linter for Makefiles
                'ruff', -- Python linter and formatter
                'csharpier', -- C# FORMATTER
            },
            automatic_installation = true,
        }

        local sources = {
            diagnostics.checkmake,
            formatting.prettier.with { 
                filetypes = { 'html', 'json', 'yaml', 'markdown', 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
                extra_args = { 
                    '--tab-width', '4',
                    '--print-width', '160',
                    '--use-tabs', 'false',
                    '--end-of-line', 'lf'
                }
            },
            formatting.stylua,
            formatting.shfmt.with { args = { '-i', '4', '-ln', 'bash' } },
            formatting.terraform_fmt,
            formatting.csharpier.with { extra_args = { '--indent-size', '4', '--line-length', '160' } },
            require('none-ls.formatting.ruff').with { extra_args = { '--extend-select', 'I', '--line-length', '160', '--indent-width', '4' } },
            require 'none-ls.formatting.ruff_format',
        }

        local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
        null_ls.setup {
            -- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
            sources = sources,
            -- you can reuse a shared lspconfig on_attach callback here
            on_attach = function(client, bufnr)
                if client.supports_method 'textDocument/formatting' then
                    vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
                    vim.api.nvim_create_autocmd('BufWritePre', {
                        group = augroup,
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format { async = false }
                        end,
                    })
                end
            end,
        }
    end,
}

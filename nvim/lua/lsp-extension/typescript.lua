-- TYPESCRIPT LSP CONFIGURATION

local M = {}

function M.setup(capabilities)
    -- CONFIGURATION FOR TYPESCRIPT/JAVASCRIPT
    -- USING TS_LS INSTEAD OF DEPRECATED TSSERVER
    require('lspconfig').ts_ls.setup {
        capabilities = capabilities,
        settings = {
            typescript = {
                inlayHints = {
                    includeInlayParameterNameHints = 'all',
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
                preferences = {
                    importModuleSpecifier = 'relative',
                },
            },
            javascript = {
                inlayHints = {
                    includeInlayParameterNameHints = 'all',
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
                preferences = {
                    importModuleSpecifier = 'relative',
                },
            },
        },
    }

    -- SETUP TYPESCRIPT-TOOLS
    require('typescript-tools').setup {
        on_attach = function(client, bufnr)
            -- DEFAULT KEYMAPS FOR TYPESCRIPT-TOOLS
            local map = function(keys, func, desc)
                vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'TypeScript: ' .. desc })
            end

            map('<leader>co', '<cmd>TSToolsOrganizeImports<cr>', 'Organize Imports')
            map('<leader>cs', '<cmd>TSToolsSortImports<cr>', 'Sort Imports')
            map('<leader>cu', '<cmd>TSToolsRemoveUnused<cr>', 'Remove Unused Imports')
            map('<leader>ca', '<cmd>TSToolsAddMissingImports<cr>', 'Add Missing Imports')
            map('<leader>cA', '<cmd>TSToolsFixAll<cr>', 'Fix All Issues')

            -- SHORTCUT FOR GENERATING A MISSING TYPE
            map('<leader>cg', function()
                -- DIRECT APPROACH WITHOUT FILTERING
                vim.lsp.buf.code_action()
            end, 'Generate Type')
        end,
        settings = {
            -- TYPESCRIPT TOOLS SETTINGS
            complete_function_calls = true,
            include_completions_with_insert_text = true,
            tsserver_file_preferences = {
                importModuleSpecifierPreference = 'relative',
                includeCompletionsForImportStatements = true,
                includeCompletionsForModuleExports = true,
                includeCompletionsWithSnippetText = true,
                includeAutomaticOptionalChainCompletions = true,
                includeCompletionsWithInsertText = true,
            },
            tsserver_format_options = {
                allowIncompleteCompletions = true,
                allowRenameOfImportPath = true,
            },
        },
    }
end

return M

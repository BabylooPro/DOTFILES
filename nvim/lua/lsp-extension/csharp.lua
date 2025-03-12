-- C# LSP CONFIGURATION

local M = {}

function M.setup(capabilities)
    -- OMNISHARP CONFIGURATION FOR C# (BETTER IMPORT HANDLING)
    require('lspconfig').omnisharp.setup {
        capabilities = capabilities,
        cmd = {
            'omnisharp',
            '--languageserver',
            '--hostPID',
            tostring(vim.fn.getpid()),
        },
        handlers = {
            ['textDocument/definition'] = require('omnisharp_extended').handler,
        },
        on_new_config = function(new_config, new_root_dir)
            -- EXPLICITLY INDICATE THE PROJECT PATH
            table.insert(new_config.cmd, '-s')
            table.insert(new_config.cmd, new_root_dir)
        end,
        on_attach = function(client, bufnr)
            -- SEMANTIC TOKENS FIX FOR OMNISHARP
            -- SOLUTION TO KNOWN ISSUE: https://github.com/OmniSharp/omnisharp-roslyn/issues/2483
            client.server_capabilities.semanticTokensProvider = {
                full = vim.empty_dict(),
                legend = {
                    tokenModifiers = { 'static_symbol' },
                    tokenTypes = {
                        'comment',
                        'excluded_code',
                        'identifier',
                        'keyword',
                        'keyword_control',
                        'number',
                        'operator',
                        'operator_overloaded',
                        'preprocessor_keyword',
                        'string',
                        'whitespace',
                        'text',
                        'static_symbol',
                        'preprocessor_text',
                        'punctuation',
                        'string_verbatim',
                        'string_escape_character',
                        'class_name',
                        'delegate_name',
                        'enum_name',
                        'interface_name',
                        'module_name',
                        'struct_name',
                        'type_parameter_name',
                        'field_name',
                        'enum_member_name',
                        'constant_name',
                        'local_name',
                        'parameter_name',
                        'method_name',
                        'extension_method_name',
                        'property_name',
                        'event_name',
                        'namespace_name',
                        'label_name',
                        'xml_doc_comment_attribute_name',
                        'xml_doc_comment_attribute_quotes',
                        'xml_doc_comment_attribute_value',
                        'xml_doc_comment_cdata_section',
                        'xml_doc_comment_comment',
                        'xml_doc_comment_delimiter',
                        'xml_doc_comment_entity_reference',
                        'xml_doc_comment_name',
                        'xml_doc_comment_processing_instruction',
                        'xml_doc_comment_text',
                        'xml_literal_attribute_name',
                        'xml_literal_attribute_quotes',
                        'xml_literal_attribute_value',
                        'xml_literal_cdata_section',
                        'xml_literal_comment',
                        'xml_literal_delimiter',
                        'xml_literal_embedded_expression',
                        'xml_literal_entity_reference',
                        'xml_literal_name',
                        'xml_literal_processing_instruction',
                        'xml_literal_text',
                        'regex_comment',
                        'regex_character_class',
                        'regex_anchor',
                        'regex_quantifier',
                        'regex_grouping',
                        'regex_alternation',
                        'regex_text',
                        'regex_self_escaped_character',
                        'regex_other_escape',
                    },
                },
                range = true,
            }

            -- ADD SPECIFIC KEYMAPS FOR C#
            vim.keymap.set('n', '<leader>ci', function()
                vim.lsp.buf.code_action {
                    context = {
                        only = {
                            'source.addMissingImports',
                            'source.fixAll',
                        },
                        diagnostics = {},
                    },
                }
            end, { buffer = bufnr, desc = 'C# Add Imports' })

            -- SHORTCUT FOR GENERATING MISSING TYPE
            vim.keymap.set('n', '<leader>cg', function()
                vim.lsp.buf.code_action()
            end, { buffer = bufnr, desc = 'C# Generate Type' })

            -- OTHER USEFUL KEYMAPPINGS
            vim.keymap.set('n', '<leader>co', function()
                vim.lsp.buf.code_action {
                    context = {
                        only = {
                            'source.organizeImports',
                        },
                        diagnostics = {},
                    },
                }
            end, { buffer = bufnr, desc = 'C# Organize Imports' })
        end,
        settings = {
            FormattingOptions = {
                EnableEditorConfigSupport = true,
                OrganizeImports = true,
            },
            RoslynExtensionsOptions = {
                EnableImportCompletion = true,
                EnableAnalyzersSupport = true,
            },
        },
    }

    -- REGISTER UTILITY COMMANDS FOR C#
    M.register_commands()
end

-- REGISTER UTILITY COMMANDS FOR OMNISHARP
function M.register_commands()
    -- DEBUG COMMAND FOR OMNISHARP
    vim.api.nvim_create_user_command('DebugOmniSharp', function()
        -- CHECK IF THE SERVER IS RUNNING
        local clients = vim.lsp.get_active_clients { name = 'omnisharp' }
        if #clients > 0 then
            local client = clients[1]
            -- DISPLAY THE SERVER CAPABILITIES
            print('OmniSharp is active. ID: ' .. client.id)
            print('Root path: ' .. (client.config.root_dir or 'Not defined'))
            print('Version: ' .. (client.version or 'Unknown'))

            -- DISPLAY THE AVAILABLE COMMANDS
            if client.server_capabilities.executeCommandProvider then
                print 'Available commands:'
                if client.server_capabilities.executeCommandProvider.commands then
                    for _, cmd in ipairs(client.server_capabilities.executeCommandProvider.commands) do
                        print('  - ' .. cmd)
                    end
                else
                    print '  No commands found'
                end
            else
                print 'The server does not support executing commands'
            end

            -- DISPLAY THE CODE ACTION CAPABILITIES
            print('Support des code actions: ' .. tostring(client.server_capabilities.codeActionProvider ~= nil))

            -- TRY TO FORCE A REINDEXATION
            print 'Attempting to force a reindexing...'
            vim.lsp.buf.execute_command {
                command = 'omnisharp.reloadSolution',
                arguments = {},
            }
        else
            print 'OmniSharp is not active in this buffer'

            -- CHECK IF OMNISHARP IS INSTALLED
            if vim.fn.executable 'omnisharp' == 1 then
                print('OmniSharp is installed on the system. Path: ' .. vim.fn.exepath 'omnisharp')
                print 'To start manually: :LspStart omnisharp'
            else
                print 'OmniSharp is not installed. Install it via :Mason'
            end
        end
    end, {})

    -- COMMAND TO FIX OMNISHARP PROBLEMS
    vim.api.nvim_create_user_command('FixOmniSharp', function()
        -- STOP OMNISHARP IF IT'S RUNNING
        vim.cmd 'LspStop omnisharp'

        -- DELETE THE OMNISHARP CACHE
        local cache_dir = vim.fn.expand '~/.cache/omnisharp'
        if vim.fn.isdirectory(cache_dir) == 1 then
            print 'Deleting OmniSharp cache...'
            vim.fn.system('rm -rf ' .. cache_dir)
        end

        -- WAIT A LITTLE
        vim.defer_fn(function()
            -- RESTART OMNISHARP
            print 'Restarting OmniSharp...'
            vim.cmd 'LspStart omnisharp'

            -- DISPLAY A MESSAGE WHEN DONE
            vim.defer_fn(function()
                print 'OmniSharp has been restarted. Use :DebugOmniSharp to check its status.'
            end, 3000)
        end, 1000)
    end, {})

    -- COMMAND TO REINSTALL OMNISHARP COMPLETELY
    vim.api.nvim_create_user_command('ReinstallOmniSharp', function()
        -- STOP ALL LSP CLIENTS
        vim.cmd 'LspStop'

        -- DISPLAY MESSAGE
        print 'Uninstalling OmniSharp...'

        -- DELETE THE CACHE
        vim.fn.system 'rm -rf ~/.cache/omnisharp'

        -- DELETE THE OMNISHARP FILES
        vim.fn.system 'rm -rf ~/.local/share/nvim/mason/packages/omnisharp'
        vim.fn.system 'rm -f ~/.local/share/nvim/mason/bin/omnisharp'

        -- REINSTALL VIA MASON
        vim.defer_fn(function()
            print 'Reinstalling OmniSharp via Mason...'
            vim.cmd 'MasonInstall omnisharp'

            -- FINISH MESSAGE
            vim.defer_fn(function()
                print 'Reinstallation finished. Restart Neovim and run :LspStart omnisharp in a .cs file'
            end, 10000)
        end, 1000)
    end, {})

    -- COMMAND TO TEST OMNISHARP DIRECTLY
    vim.api.nvim_create_user_command('TestOmniSharp', function()
        -- DISPLAY MESSAGE
        print 'Executing a direct test of OmniSharp...'

        -- VERIFY IF OMNISHARP IS IN THE PATH
        if vim.fn.executable 'omnisharp' == 1 then
            print 'The OmniSharp binary is found in the PATH'
            -- EXECUTE OMNISHARP WITH --HELP
            local result = vim.fn.system 'omnisharp --help'
            print "Result of 'omnisharp --help':"
            print(result)
        else
            print 'ERROR: omnisharp is not found in the PATH'
        end

        -- TEST DIRECT EXECUTION WITH DOTNET
        local omnisharp_dll = vim.fn.expand '~/.local/share/nvim/mason/packages/omnisharp/libexec/OmniSharp.dll'
        if vim.fn.filereadable(omnisharp_dll) == 1 then
            print('OmniSharp.dll is found at: ' .. omnisharp_dll)
            print 'Testing direct execution with dotnet...'
            -- TEST DOTNET WITH OMNISHARP.DLL
            local result = vim.fn.system('dotnet ' .. omnisharp_dll .. ' --help')
            print "Result of 'dotnet OmniSharp.dll --help':"
            print(result)
        else
            print('ERROR: OmniSharp.dll is not found at ' .. omnisharp_dll)
        end

        print 'Test finished. Check the results above.'
    end, {})

    -- COMMAND TO DISPLAY ALL AVAILABLE CODE ACTIONS
    vim.api.nvim_create_user_command('ShowCodeActions', function()
        -- VERIFY IF WE ARE IN A C# BUFFER
        if vim.bo.filetype ~= 'cs' then
            print('This command is designed for C# files. Current filetype: ' .. vim.bo.filetype)
            return
        end

        -- GET THE OMNISHARP CLIENT
        local clients = vim.lsp.get_active_clients { name = 'omnisharp' }
        if #clients == 0 then
            print 'OmniSharp is not connected. Use :LspStart omnisharp'
            return
        end

        print 'Retrieving available code actions...'

        -- GET THE CODE ACTIONS WITHOUT FILTER
        vim.lsp.buf_request(0, 'textDocument/codeAction', vim.lsp.util.make_range_params(), function(err, result, ctx, config)
            if err then
                print('Error retrieving code actions:', err)
                return
            end

            if not result or #result == 0 then
                print 'No code actions available at this position.'
                return
            end

            print('Available code actions (' .. #result .. '):')
            for i, action in ipairs(result) do
                print(i .. '. ' .. action.title .. ' (kind: ' .. (action.kind or 'not specified') .. ')')
            end
        end)
    end, {})

    -- COMMAND TO FORCE ADDING IMPORTS MANUALLY
    vim.api.nvim_create_user_command('CsAddImport', function(opts)
        -- VERIFY IF WE ARE IN A C# BUFFER
        if vim.bo.filetype ~= 'cs' then
            print('This command is designed for C# files. Current filetype: ' .. vim.bo.filetype)
            return
        end

        -- GET THE OMNISHARP CLIENT
        local clients = vim.lsp.get_active_clients { name = 'omnisharp' }
        if #clients == 0 then
            print 'OmniSharp is not connected. Use :LspStart omnisharp'
            return
        end

        -- VERIFY IF A NAMESPACE HAS BEEN PROVIDED
        if not opts.args or opts.args == '' then
            print 'Please specify a namespace to import. Example: :CsAddImport System.Collections.Generic'
            return
        end

        -- GET THE CONTENT OF THE CURRENT BUFFER
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local content = table.concat(lines, '\n')

        -- VERIFY IF THE NAMESPACE IS ALREADY IMPORTED
        if content:match('using%s+' .. opts.args .. '%s*;') then
            print("The namespace '" .. opts.args .. "' is already imported.")
            return
        end

        -- FIND THE POSITION TO ADD THE IMPORT
        local insert_line = 0
        local last_using_line = 0

        -- SEARCH THE LAST "USING" LINE
        for i, line in ipairs(lines) do
            if line:match '^%s*using%s+' then
                last_using_line = i
            end
            if line:match '^%s*namespace%s+' then
                break
            end
        end

        -- DETERMINE THE INSERT LINE
        if last_using_line > 0 then
            insert_line = last_using_line
        end

        -- ADD THE IMPORT
        local import_statement = 'using ' .. opts.args .. ';'
        if insert_line > 0 then
            vim.api.nvim_buf_set_lines(0, insert_line, insert_line, false, { import_statement })
            print('Import added: ' .. import_statement)
        else
            -- ADD TO THE BEGINNING OF THE FILE
            vim.api.nvim_buf_set_lines(0, 0, 0, false, { import_statement, '' })
            print('Import added to the beginning of the file: ' .. import_statement)
        end
    end, { nargs = '?' })

    -- COMMAND FOR INSTALLING AND CONFIGURING CSHARP-LS (ALTERNATIVE TO OMNISHARP)
    vim.api.nvim_create_user_command('UseCSharpLS', function()
        -- STOP OMNISHARP IF IT'S RUNNING
        vim.cmd 'LspStop omnisharp'

        -- INSTALL CSHARP-LS VIA MASON
        print 'Installing csharp-ls via Mason...'
        vim.cmd 'MasonInstall csharp-ls'

        -- WAIT A LITTLE
        vim.defer_fn(function()
            -- CREATE A TEMPORARY CONFIGURATION FOR CSHARP-LS
            print 'Configuring csharp-ls...'

            -- CONFIGURE CSHARP-LS
            require('lspconfig').csharp_ls.setup {
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    -- ADD SPECIFIC KEYMAPS FOR C#
                    vim.keymap.set('n', '<leader>ci', function()
                        vim.lsp.buf.code_action {
                            context = {
                                only = {
                                    'source.addMissingImports',
                                    'source.fixAll',
                                },
                                diagnostics = {},
                            },
                        }
                    end, { buffer = bufnr, desc = 'C# Add Imports' })

                    -- OTHER USEFUL KEYMAPS
                    vim.keymap.set('n', '<leader>co', function()
                        vim.lsp.buf.code_action {
                            context = {
                                only = {
                                    'source.organizeImports',
                                },
                                diagnostics = {},
                            },
                        }
                    end, { buffer = bufnr, desc = 'C# Organize Imports' })

                    print 'csharp-ls configured. Restart Neovim and open a .cs file'
                end,
            }

            -- START CSHARP-LS
            print 'Starting csharp-ls...'
            vim.cmd 'LspStart csharp_ls'

            -- DISPLAY A MESSAGE WHEN DONE
            vim.defer_fn(function()
                print 'csharp-ls is now configured as an alternative to OmniSharp.'
                print 'To switch back to OmniSharp, use :ReinstallOmniSharp'
            end, 3000)
        end, 5000)
    end, {})
end

return M

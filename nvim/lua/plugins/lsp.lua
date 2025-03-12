return {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
        -- Automatically install LSPs and related tools to stdpath for Neovim
        { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
        'williamboman/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',

        -- Allows extra capabilities provided by nvim-cmp
        'hrsh7th/cmp-nvim-lsp',

        -- TYPESCRIPT TOOLS - BETTER THAN TSSERVER FOR IMPORTS AND MORE
        {
            'pmizio/typescript-tools.nvim',
            dependencies = { 'nvim-lua/plenary.nvim' },
        },

        -- OMNISHARP EXTENDED LSP - ADDED FUNCTIONALITIES FOR C# IMPORTS
        { 'Hoffs/omnisharp-extended-lsp.nvim' },
    },
    config = function()
        -- ADVANCED LSP PROGRESS TRACKING
        ---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
        local progress = vim.defaulttable()
        vim.api.nvim_create_autocmd('LspProgress', {
            ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
            callback = function(ev)
                local client = vim.lsp.get_client_by_id(ev.data.client_id)
                local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
                if not client or type(value) ~= 'table' then
                    return
                end
                local p = progress[client.id]

                for i = 1, #p + 1 do
                    if i == #p + 1 or p[i].token == ev.data.params.token then
                        p[i] = {
                            token = ev.data.params.token,
                            msg = ('[%3d%%] %s%s'):format(
                                value.kind == 'end' and 100 or value.percentage or 100,
                                value.title or '',
                                value.message and (' **%s**'):format(value.message) or ''
                            ),
                            done = value.kind == 'end',
                        }
                        break
                    end
                end

                local msg = {} ---@type string[]
                progress[client.id] = vim.tbl_filter(function(v)
                    return table.insert(msg, v.msg) or not v.done
                end, p)

                local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
                vim.notify(table.concat(msg, '\n'), 'info', {
                    id = 'lsp_progress',
                    title = client.name,
                    opts = function(notif)
                        notif.icon = #progress[client.id] == 0 and ' ' or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
                    end,
                })
            end,
        })

        --  This function gets run when an LSP attaches to a particular buffer.
        --    That is to say, every time a new file is opened that is associated with
        --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
        --    function will be executed to configure the current buffer
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
            callback = function(event)
                -- NOTE: Remember that Lua is a real programming language, and as such it is possible
                -- to define small helper and utility functions so you don't have to repeat yourself.
                --
                -- In this case, we create a function that lets us more easily define mappings specific
                -- for LSP related items. It sets the mode, buffer and description for us each time.
                local map = function(keys, func, desc, mode)
                    mode = mode or 'n'
                    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                end

                -- Jump to the definition of the word under your cursor.
                --  This is where a variable was first declared, or where a function is defined, etc.
                --  To jump back, press <C-t>.
                map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

                -- Find references for the word under your cursor.
                map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

                -- Jump to the implementation of the word under your cursor.
                --  Useful when your language has ways of declaring types without an actual implementation.
                map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

                -- Jump to the type of the word under your cursor.
                --  Useful when you're not sure what type a variable is and you want to see
                --  the definition of its *type*, not where it was *defined*.
                map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

                -- Fuzzy find all the symbols in your current document.
                --  Symbols are things like variables, functions, types, etc.
                map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

                -- Fuzzy find all the symbols in your current workspace.
                --  Similar to document symbols, except searches over your entire project.
                map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

                -- Rename the variable under your cursor.
                --  Most Language Servers support renaming across files, etc.
                map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

                -- Execute a code action, usually your cursor needs to be on top of an error
                -- or a suggestion from your LSP for this to activate.
                map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

                -- GLOBAL SHORTCUTS FOR IMPORT MANAGEMENT
                -- THESE SHORTCUTS WORK FOR ALL LANGUAGES THAT SUPPORT THESE FEATURES

                -- ADD MISSING IMPORT
                map('<leader>ci', function()
                    -- TRY TO EXECUTE LANGUAGE-SPECIFIC COMMAND
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client then
                        local commands = client.server_capabilities.executeCommandProvider
                        if commands then
                            local command_names = commands.commands or {}

                            -- LOOK FOR APPROPRIATE IMPORT COMMAND
                            local import_commands = {
                                'csharp.addImport',
                                'typescript.addImport',
                                'python.addImport',
                                '_typescript.addImport',
                                'source.addImport',
                                'source.addMissingImports',
                            }

                            for _, cmd in ipairs(import_commands) do
                                if vim.tbl_contains(command_names, cmd) then
                                    vim.lsp.buf.execute_command {
                                        command = cmd,
                                        arguments = { vim.uri_from_bufnr(event.buf) },
                                    }
                                    return
                                end
                            end
                        end

                        -- IF NO SPECIFIC COMMAND IS FOUND, TRY CODE ACTION
                        vim.lsp.buf.code_action {
                            context = {
                                only = { 'source.addImport', 'source.addMissingImports' },
                            },
                        }
                    end
                end, 'Add Import')

                -- ORGANIZE IMPORTS
                map('<leader>co', function()
                    -- TRY TO EXECUTE LANGUAGE-SPECIFIC COMMAND
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client then
                        local commands = client.server_capabilities.executeCommandProvider
                        if commands then
                            local command_names = commands.commands or {}

                            -- LOOK FOR APPROPRIATE IMPORT ORGANIZATION COMMAND
                            local organize_commands = {
                                'csharp.organizeImports',
                                'typescript.organizeImports',
                                'python.organizeImports',
                                '_typescript.organizeImports',
                                'source.organizeImports',
                            }

                            for _, cmd in ipairs(organize_commands) do
                                if vim.tbl_contains(command_names, cmd) then
                                    vim.lsp.buf.execute_command {
                                        command = cmd,
                                        arguments = { vim.uri_from_bufnr(event.buf) },
                                    }
                                    return
                                end
                            end
                        end

                        -- IF NO SPECIFIC COMMAND IS FOUND, TRY CODE ACTION
                        vim.lsp.buf.code_action {
                            context = {
                                only = { 'source.organizeImports' },
                            },
                        }
                    end
                end, 'Organize Imports')

                -- WARN: This is not Goto Definition, this is Goto Declaration.
                --  For example, in C this would take you to the header.
                map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                -- SHOW FULL DIAGNOSTIC UNDER CURSOR
                map('<leader>fd', function()
                    -- GET ALL DIAGNOSTICS UNDER CURSOR
                    local line_diagnostics = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
                    
                    if vim.tbl_isempty(line_diagnostics) then
                        vim.notify("Aucun diagnostic trouvé sous le curseur", vim.log.levels.INFO)
                        return
                    end
                    
                    -- OPEN A FLOATING WINDOW WITH ALL THE DETAILS
                    local opts = {
                        focusable = true,
                        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                        border = 'rounded',
                        source = 'always',
                        prefix = ' ',
                        scope = 'cursor',
                        header = { "DIAGNOSTIC DETAILS", "Title" },
                        win_options = {
                            winhighlight = 'Normal:Normal,NormalFloat:Normal,FloatBorder:FloatBorder',
                        },
                    }
                    
                    vim.diagnostic.open_float(0, opts)
                end, 'Afficher [F]ull [D]iagnostic')

                -- The following two autocommands are used to highlight references of the
                -- word under your cursor when your cursor rests there for a little while.
                --    See `:help CursorHold` for information about when this is executed
                --
                -- When you move your cursor, the highlights will be cleared (the second autocommand).
                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                    local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
                    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.document_highlight,
                    })

                    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.clear_references,
                    })

                    vim.api.nvim_create_autocmd('LspDetach', {
                        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                        callback = function(event2)
                            vim.lsp.buf.clear_references()
                            vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                        end,
                    })
                end

                -- The following code creates a keymap to toggle inlay hints in your
                -- code, if the language server you are using supports them
                --
                -- This may be unwanted, since they displace some of your code
                if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                    map('<leader>th', function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
                    end, '[T]oggle Inlay [H]ints')
                end
            end,
        })

        -- LSP servers and clients are able to communicate to each other what features they support.
        --  By default, Neovim doesn't support everything that is in the LSP specification.
        --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
        --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

        -- LOAD LANGUAGE-SPECIFIC LSP CONFIGURATIONS FROM THE LSP-EXTENSION DIRECTORY
        require('lsp-extension').setup(capabilities)

        -- CONFIGURATION TO SHOW DIAGNOSTICS AUTOMATICALLY
        vim.diagnostic.config({
            float = {
                source = 'always',
                border = 'rounded',
                focusable = false,
                header = { "DIAGNOSTIC", "Title" },
                win_options = {
                    winhighlight = 'Normal:Normal,NormalFloat:Normal,FloatBorder:FloatBorder',
                },
            },
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
            virtual_text = {
                source = true,
                prefix = '●',
            },
        })

        -- SHOW DIAGNOSTIC AUTOMATICALLY WHEN CURSOR STAYS ON A LINE
        vim.o.updatetime = 250
        vim.api.nvim_create_autocmd("CursorHold", {
            pattern = "*",
            callback = function()
                vim.diagnostic.open_float(nil, { 
                    focus = false,
                    scope = "cursor",
                    win_options = {
                        winhighlight = 'Normal:Normal,NormalFloat:Normal,FloatBorder:FloatBorder',
                    }
                })
            end,
        })

        -- COMMAND TO DISPLAY/ENABLE LSP LOGS
        vim.api.nvim_create_user_command('LspDebugMode', function()
            -- ENABLE LSP LOGGING
            vim.lsp.set_log_level 'debug'
            print 'LSP log level set to DEBUG'
            print 'To see the logs, use :LspLog'

            -- CHECK LSP PROBLEMS
            vim.cmd 'checkhealth lsp'
        end, {})

        -- Ensure the servers and tools above are installed
        --  To check the current status of installed tools and/or manually install
        --  other tools, you can run
        --    :Mason
        --
        --  You can press `g?` for help in this menu.
        require('mason').setup()

        -- You can add other tools here that you want Mason to install
        -- for you, so that they are available from within Neovim.
        require('mason-tool-installer').setup {
            ensure_installed = {
                -- FORMATTERS
                'stylua', -- Lua formatter
                'eslint_d', -- JavaScript/TypeScript linter
                'prettierd', -- JavaScript/TypeScript formatter
                'ruff', -- Python linter and formatter
                'csharpier', -- C# formatter

                -- LSP SERVERS
                'typescript-language-server', -- For ts_ls
                'pyright',
                'omnisharp', -- Use .NET version instead of omnisharp-mono
                'tailwindcss-language-server',
                'dockerfile-language-server',
                'yaml-language-server',
            },
        }

        -- SETUP MASON LSP CONFIGURATION
        require('mason-lspconfig').setup {
            handlers = {
                function(server_name)
                    -- SKIP CSHARP_LS ENTIRELY - WE ONLY WANT TO USE OMNISHARP
                    if server_name == 'csharp_ls' then
                        return
                    end

                    -- SKIP SERVERS THAT ARE HANDLED BY LSP_EXTENSION
                    -- THIS PREVENTS DOUBLE INITIALIZATION
                    local skip_servers = {
                        'ts_ls',
                        'omnisharp',
                        'pyright',
                        'pylsp',
                        'ruff',
                        'lua_ls',
                        'html',
                        'cssls',
                        'tailwindcss', -- "jdtls",
                        'sourcekit',
                        'dockerls',
                        'yamlls',
                        'jsonls',
                        'terraformls',
                        'sqlls',
                    }

                    if vim.tbl_contains(skip_servers, server_name) then
                        return
                    end

                    -- SETUP ANY OTHER SERVERS THAT AREN'T EXPLICITLY CONFIGURED
                    require('lspconfig')[server_name].setup {
                        capabilities = capabilities,
                    }
                end,
            },
        }
    end,
}

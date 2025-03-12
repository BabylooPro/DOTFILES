-- PYTHON LSP CONFIGURATION

local M = {}

-- COMMON PYTHON MODULES AND THEIR EXPORTS
-- USING THIS FOR AUTO-IMPORT SUGGESTIONS
local common_modules = {
    -- STANDARD LIBRARY
    os = { 'path', 'environ', 'getcwd', 'listdir', 'mkdir', 'makedirs', 'remove', 'rmdir', 'walk', 'system' },
    sys = { 'argv', 'exit', 'path', 'stdout', 'stderr', 'platform' },
    re = { 'compile', 'search', 'match', 'findall', 'sub', 'split' },
    math = { 'ceil', 'floor', 'sqrt', 'sin', 'cos', 'tan', 'pi', 'radians', 'degrees' },
    random = { 'randint', 'choice', 'shuffle', 'random', 'uniform', 'seed', 'sample' },
    time = { 'time', 'sleep', 'strftime', 'gmtime', 'localtime' },
    datetime = { 'datetime', 'date', 'time', 'timedelta' },
    json = { 'loads', 'dumps', 'load', 'dump' },
    csv = { 'reader', 'writer', 'DictReader', 'DictWriter' },
    pathlib = { 'Path', 'PurePath' },
    typing = { 'List', 'Dict', 'Tuple', 'Set', 'Optional', 'Union', 'Any', 'Callable' },
    collections = { 'defaultdict', 'Counter', 'deque', 'namedtuple', 'OrderedDict' },
    functools = { 'partial', 'reduce', 'wraps', 'lru_cache' },
    itertools = { 'chain', 'cycle', 'islice', 'product', 'permutations', 'combinations' },

    -- POPULAR THIRD-PARTY LIBRARIES
    numpy = { 'array', 'ndarray', 'arange', 'zeros', 'ones', 'eye', 'linspace', 'random', 'linalg', 'mean', 'median', 'std' },
    pandas = { 'DataFrame', 'Series', 'read_csv', 'read_excel', 'read_json', 'concat', 'merge' },
    matplotlib = { 'pyplot', 'figure', 'plot', 'scatter', 'hist', 'bar', 'savefig', 'title', 'xlabel', 'ylabel' },
    ['matplotlib.pyplot'] = { 'plot', 'figure', 'savefig', 'show', 'title', 'xlabel', 'ylabel', 'legend' },
    requests = { 'get', 'post', 'put', 'delete', 'session', 'request' },
    flask = { 'Flask', 'request', 'jsonify', 'render_template', 'redirect', 'url_for' },
    django = { 'models', 'views', 'urls', 'forms', 'settings' },
    ['django.db'] = { 'models' },
    ['django.http'] = { 'HttpResponse', 'JsonResponse', 'HttpRequest' },
    ['django.shortcuts'] = { 'render', 'redirect', 'get_object_or_404' },
    sqlalchemy = { 'create_engine', 'Column', 'Integer', 'String', 'Boolean', 'Float', 'DateTime', 'ForeignKey' },
    pytest = { 'fixture', 'mark', 'raises', 'approx', 'parameterize' },
    boto3 = { 'client', 'resource' },
    torch = { 'nn', 'optim', 'cuda', 'tensor', 'load', 'save' },
    tensorflow = { 'keras', 'data', 'nn', 'train', 'io' },
    pydantic = { 'BaseModel', 'Field', 'validator', 'root_validator' },
    typing_extensions = { 'TypedDict', 'Literal', 'Protocol', 'TypeAlias' },

    -- PATHLIB
    ['pathlib'] = { 'Path', 'PurePath', 'PurePosixPath', 'PureWindowsPath' },
}

-- SEARCH FOR POTENTIAL IMPORTS FOR AN UNDEFINED SYMBOL
local function find_potential_import(symbol)
    local suggestions = {}

    -- SEARCH IN COMMON MODULES
    for module, exports in pairs(common_modules) do
        for _, export in ipairs(exports) do
            if export == symbol then
                table.insert(suggestions, { module = module, object = export })
            elseif string.lower(export) == string.lower(symbol) then
                table.insert(suggestions, { module = module, object = export, case_insensitive = true })
            end
        end

        -- CHECK IF THE SYMBOL IS A MODULE ITSELF
        if module:match '[^.]+$' == symbol then
            table.insert(suggestions, { module = module, is_module = true })
        end
    end

    return suggestions
end

-- FUNCTION TO PROPOSE IMPORTS TO THE USER
local function suggest_imports(symbol, bufnr)
    local suggestions = find_potential_import(symbol)

    if #suggestions == 0 then
        -- NO SUGGESTIONS FOUND
        vim.notify('No import suggestions found for: ' .. symbol, vim.log.levels.INFO)
        return false
    elseif #suggestions == 1 then
        -- ONE SUGGESTION, APPLY AUTOMATICALLY
        local suggestion = suggestions[1]
        if suggestion.is_module then
            vim.cmd('PyAddImport ' .. suggestion.module)
            return true
        else
            vim.cmd('PyFromImport ' .. suggestion.module .. ' ' .. suggestion.object)
            return true
        end
    else
        -- MULTIPLE SUGGESTIONS, DISPLAY A MENU
        local options = {}
        for i, suggestion in ipairs(suggestions) do
            if suggestion.is_module then
                table.insert(options, i .. '. import ' .. suggestion.module)
            else
                if suggestion.case_insensitive then
                    table.insert(options, i .. '. from ' .. suggestion.module .. ' import ' .. suggestion.object .. ' (case insensitive)')
                else
                    table.insert(options, i .. '. from ' .. suggestion.module .. ' import ' .. suggestion.object)
                end
            end
        end

        -- ADD AN OPTION FOR MANUAL INPUT
        table.insert(options, #options + 1 .. '. Enter manually...')

        -- DISPLAY THE MENU
        vim.ui.select(options, {
            prompt = "Select import for '" .. symbol .. "':",
        }, function(choice, idx)
            if not choice then
                return
            end

            if idx <= #suggestions then
                local suggestion = suggestions[idx]
                if suggestion.is_module then
                    vim.cmd('PyAddImport ' .. suggestion.module)
                else
                    vim.cmd('PyFromImport ' .. suggestion.module .. ' ' .. suggestion.object)
                end
            else
                -- MANUAL INPUT
                vim.ui.input({
                    prompt = "Enter import (e.g. 'module' or 'from module import object'):",
                }, function(input)
                    if not input or input == '' then
                        return
                    end

                    if input:match '^from%s+' then
                        local from_part = input:match '^from%s+([^%s]+)%s+'
                        local import_part = input:match 'import%s+([^%s]+)'

                        if from_part and import_part then
                            vim.cmd('PyFromImport ' .. from_part .. ' ' .. import_part)
                        else
                            vim.notify("Invalid format. Use 'from module import object'", vim.log.levels.ERROR)
                        end
                    else
                        vim.cmd('PyAddImport ' .. input)
                    end
                end)
            end
        end)
        return true
    end
end

function M.setup(capabilities)
    -- COMMON ON_ATTACH FUNCTION FOR PYTHON LSPS
    local on_attach = function(client, bufnr)
        -- IMPORT MANAGEMENT KEYMAPS
        vim.keymap.set('n', '<leader>ci', function()
            -- FOR PYRIGHT/PYLSP
            vim.lsp.buf.code_action {
                context = {
                    only = {
                        'source.organizeImports',
                        'source.addMissingImports',
                        'quickfix.addMissingImports',
                        'quickfix.import',
                    },
                    diagnostics = {},
                },
            }
        end, { buffer = bufnr, desc = 'Python Add Imports' })

        -- SHORTCUT FOR GENERATING MISSING TYPE/STUB - LIKE IN CSHARP/TS
        vim.keymap.set('n', '<leader>cg', function()
            -- GET WORD UNDER CURSOR
            local word = vim.fn.expand '<cword>'

            -- CHECK IF WORD IS DIAGNOSTICS-RELATED (LIKE A MISSING IMPORT)
            local has_diagnostics = false
            local is_undefined = false
            local cursor_pos = vim.api.nvim_win_get_cursor(0)
            local line = cursor_pos[1] - 1
            local col = cursor_pos[2]

            -- GET DIAGNOSTICS AT CURSOR POSITION
            local diagnostics = vim.diagnostic.get(bufnr)
            for _, diagnostic in ipairs(diagnostics) do
                if
                    diagnostic.lnum == line
                    and col >= diagnostic.col
                    and col <= diagnostic.end_col
                    and (
                        diagnostic.message:match 'undefined'
                        or diagnostic.message:match 'not defined'
                        or diagnostic.message:match "name '.*' is not defined"
                        or diagnostic.message:match "'.*' is not defined"
                        or diagnostic.message:match "module '.*' has no attribute '.*'"
                        or diagnostic.message:match 'unable to import'
                        or diagnostic.message:match 'unknown'
                    )
                then
                    has_diagnostics = true
                    is_undefined = true
                    break
                elseif diagnostic.lnum == line and col >= diagnostic.col and col <= diagnostic.end_col then
                    has_diagnostics = true
                end
            end

            -- IF IT'S A MISSING IMPORT PROBLEM, USE OUR CUSTOM SYSTEM
            if is_undefined then
                if suggest_imports(word, bufnr) then
                    return
                end
            end

            -- OTHERWISE, TRY STANDARD CODE ACTIONS
            if has_diagnostics then
                vim.lsp.buf.code_action {
                    context = {
                        diagnostics = vim.diagnostic.get(bufnr, { lnum = line }),
                    },
                }
            else
                -- IF NO DIAGNOSTIC, JUST DISPLAY ALL AVAILABLE ACTIONS
                vim.lsp.buf.code_action()
            end
        end, { buffer = bufnr, desc = 'Python Generate Import/Fix' })

        -- MANUAL IMPORT PROMPT
        vim.keymap.set('n', '<leader>cm', function()
            -- ASK FOR MODULE TO IMPORT
            vim.ui.input({ prompt = 'Module to import: ' }, function(module)
                if module and module ~= '' then
                    -- CHECK IF IT'S A SIMPLE IMPORT OR FROM IMPORT
                    if module:match '^from%s+' then
                        -- EXTRACT PARTS OF THE FROM IMPORT
                        local from_part = module:match '^from%s+([^%s]+)%s+'
                        local import_part = module:match 'import%s+([^%s]+)'

                        if from_part and import_part then
                            -- EXECUTE THE FROM IMPORT COMMAND
                            vim.cmd('PyFromImport ' .. from_part .. ' ' .. import_part)
                        else
                            print "Invalid format. Use 'from module import object'"
                        end
                    else
                        -- SIMPLE IMPORT
                        vim.cmd('PyAddImport ' .. module)
                    end
                end
            end)
        end, { buffer = bufnr, desc = 'Python Manual Import' })

        -- SHORTCUT TO DISPLAY ALL CODE ACTIONS
        vim.keymap.set('n', '<leader>ca', function()
            vim.lsp.buf.code_action()
        end, { buffer = bufnr, desc = 'Python Code Actions' })

        -- ORGANIZE IMPORTS
        vim.keymap.set('n', '<leader>co', function()
            -- FOR PYRIGHT/PYLSP
            if client.name == 'ruff' then
                -- SPECIFIC TO RUFF
                vim.lsp.buf.code_action {
                    context = {
                        only = {
                            'ruff.organizeImports',
                        },
                        diagnostics = {},
                    },
                }
            else
                vim.lsp.buf.code_action {
                    context = {
                        only = {
                            'source.organizeImports',
                            'quickfix.organizeImports',
                        },
                        diagnostics = {},
                    },
                }
            end
        end, { buffer = bufnr, desc = 'Python Organize Imports' })

        -- REMOVE UNUSED IMPORTS
        vim.keymap.set('n', '<leader>cu', function()
            vim.lsp.buf.code_action {
                context = {
                    only = {
                        'source.removeUnusedImports',
                        'quickfix.removeUnusedImports',
                    },
                    diagnostics = {},
                },
            }
        end, { buffer = bufnr, desc = 'Python Remove Unused Imports' })

        -- FIX ALL PROBLEMS (RUFF)
        vim.keymap.set('n', '<leader>cf', function()
            if client.name == 'ruff' then
                vim.lsp.buf.code_action {
                    context = {
                        only = {
                            'ruff.fixAll',
                        },
                        diagnostics = {},
                    },
                }
            else
                vim.lsp.buf.code_action {
                    context = {
                        only = {
                            'source.fixAll',
                            'quickfix.fixAll',
                        },
                        diagnostics = {},
                    },
                }
            end
        end, { buffer = bufnr, desc = 'Python Fix All Problems' })

        -- SPECIFIC SHORTCUTS FOR RUFF
        if client.name == 'ruff' then
            -- DISABLE RUFF FOR THIS LINE
            vim.keymap.set('n', '<leader>cd', function()
                vim.lsp.buf.code_action {
                    context = {
                        only = {
                            'ruff.disableRule',
                        },
                        diagnostics = {},
                    },
                }
            end, { buffer = bufnr, desc = 'Disable Ruff for this line' })
        end
    end

    -- CONFIGURATION FOR PYRIGHT
    require('lspconfig').pyright.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            python = {
                analysis = {
                    autoImportCompletions = true,
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    typeCheckingMode = 'basic',
                    diagnosticMode = 'workspace',
                    inlayHints = {
                        variableTypes = true,
                        functionReturnTypes = true,
                    },
                    -- ENABLE IMPORT SUGGESTIONS
                    importSuggestions = true,
                    -- INTELLIGENT COMPLETION
                    completeFunctionParens = true,
                },
                -- ENABLE CODE SUGGESTIONS
                suggest = {
                    autoImports = true,
                },
            },
        },
        before_init = function(params, config)
            -- ADD ADDITIONAL SEARCH PATHS
            local path = require('lspconfig/util').path
            local python_path = vim.fn.exepath 'python3' or vim.fn.exepath 'python' or 'python'
            if python_path then
                config.settings.python.pythonPath = python_path
            end

            -- TRY TO FIND A VIRTUAL ENVIRONMENT
            local venv_path = os.getenv 'VIRTUAL_ENV'
            if venv_path then
                config.settings.python.venvPath = venv_path
            end
        end,
    }

    -- CONFIGURATION FOR PYLSP (PYTHON LANGUAGE SERVER)
    require('lspconfig').pylsp.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            pylsp = {
                plugins = {
                    pyflakes = { enabled = false },
                    pycodestyle = { enabled = false },
                    autopep8 = { enabled = false },
                    yapf = { enabled = false },
                    mccabe = { enabled = false },
                    pylsp_mypy = { enabled = false },
                    pylsp_black = { enabled = false },
                    pylsp_isort = { enabled = false },
                    -- ENABLE JEDI FOR AUTO-COMPLETION AND IMPORTS
                    jedi = {
                        auto_import_modules = true,
                        eager = true,
                        environment = true,
                    },
                    -- ENABLE ROPE FOR REFACTORINGS AND IMPORTS
                    rope = {
                        enabled = true,
                        autoimport = {
                            enabled = true,
                            memory = true,
                        },
                    },
                },
            },
        },
    }

    -- CONFIGURATION FOR RUFF (PYTHON LINTER)
    require('lspconfig').ruff.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        init_options = {
            settings = {
                -- ENABLE ADVANCED FEATURES OF RUFF
                organizeImports = true,
                fixAll = true,
                codeAction = {
                    fixViolation = true,
                    disableRule = true,
                },
            },
        },
    }

    -- REGISTER UTILITY COMMANDS FOR PYTHON
    M.register_commands()
end

-- REGISTER UTILITY COMMANDS FOR PYTHON
function M.register_commands()
    -- COMMAND TO MANUALLY ADD IMPORT
    vim.api.nvim_create_user_command('PyAddImport', function(opts)
        -- VERIFY IF WE ARE IN A PYTHON BUFFER
        if vim.bo.filetype ~= 'python' then
            print('This command is designed for Python files. Current filetype: ' .. vim.bo.filetype)
            return
        end

        -- VERIFY IF A MODULE HAS BEEN PROVIDED
        if not opts.args or opts.args == '' then
            print 'Please specify a module to import. Example: :PyAddImport os'
            return
        end

        -- PARSE THE IMPORT STATEMENT
        local import_parts = vim.split(opts.args, ' as ')
        local module = import_parts[1]
        local alias = import_parts[2]

        -- GET THE CONTENT OF THE CURRENT BUFFER
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local content = table.concat(lines, '\n')

        -- VERIFY IF THE MODULE IS ALREADY IMPORTED
        local import_pattern = 'import%s+' .. module:gsub('%.', '%.') .. '%s*'
        if alias then
            import_pattern = import_pattern .. 'as%s+' .. alias
        end

        if content:match(import_pattern) then
            print("The module '" .. module .. "' is already imported.")
            return
        end

        -- FIND THE POSITION TO ADD THE IMPORT
        local insert_line = 0
        local last_import_line = 0

        -- SEARCH THE LAST IMPORT LINE
        for i, line in ipairs(lines) do
            if line:match '^%s*import%s+' or line:match '^%s*from%s+' then
                last_import_line = i
            elseif line:match '^%s*class%s+' or line:match '^%s*def%s+' then
                break
            end
        end

        -- DETERMINE THE INSERT LINE
        if last_import_line > 0 then
            insert_line = last_import_line
        end

        -- CREATE THE IMPORT STATEMENT
        local import_statement
        if alias then
            import_statement = 'import ' .. module .. ' as ' .. alias
        else
            import_statement = 'import ' .. module
        end

        -- ADD THE IMPORT
        if insert_line > 0 then
            vim.api.nvim_buf_set_lines(0, insert_line, insert_line, false, { import_statement })
            print('Import added: ' .. import_statement)
        else
            -- ADD TO THE BEGINNING OF THE FILE
            vim.api.nvim_buf_set_lines(0, 0, 0, false, { import_statement, '' })
            print('Import added to the beginning of the file: ' .. import_statement)
        end
    end, { nargs = '?' })

    -- COMMAND TO MANUALLY ADD FROM IMPORT
    vim.api.nvim_create_user_command('PyFromImport', function(opts)
        -- VERIFY IF WE ARE IN A PYTHON BUFFER
        if vim.bo.filetype ~= 'python' then
            print('This command is designed for Python files. Current filetype: ' .. vim.bo.filetype)
            return
        end

        -- VERIFY IF ARGUMENTS HAVE BEEN PROVIDED
        if not opts.args or opts.args == '' then
            print 'Please specify a module and object to import. Example: :PyFromImport os path'
            return
        end

        -- PARSE THE IMPORT STATEMENT
        local args = vim.split(opts.args, ' ')
        if #args < 2 then
            print 'Please specify both module and object. Example: :PyFromImport os path'
            return
        end

        local module = args[1]
        local object = args[2]
        local alias = args[3] and args[3] ~= 'as' and args[3] or args[4]

        -- GET THE CONTENT OF THE CURRENT BUFFER
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local content = table.concat(lines, '\n')

        -- VERIFY IF THE IMPORT IS ALREADY PRESENT
        local import_pattern = 'from%s+' .. module:gsub('%.', '%.') .. '%s+import%s+.*' .. object
        if content:match(import_pattern) then
            print("The object '" .. object .. "' from module '" .. module .. "' is already imported.")
            return
        end

        -- FIND THE POSITION TO ADD THE IMPORT
        local insert_line = 0
        local last_import_line = 0

        -- SEARCH THE LAST IMPORT LINE
        for i, line in ipairs(lines) do
            if line:match '^%s*import%s+' or line:match '^%s*from%s+' then
                last_import_line = i
            elseif line:match '^%s*class%s+' or line:match '^%s*def%s+' then
                break
            end
        end

        -- DETERMINE THE INSERT LINE
        if last_import_line > 0 then
            insert_line = last_import_line
        end

        -- CREATE THE IMPORT STATEMENT
        local import_statement
        if alias then
            import_statement = 'from ' .. module .. ' import ' .. object .. ' as ' .. alias
        else
            import_statement = 'from ' .. module .. ' import ' .. object
        end

        -- ADD THE IMPORT
        if insert_line > 0 then
            vim.api.nvim_buf_set_lines(0, insert_line, insert_line, false, { import_statement })
            print('Import added: ' .. import_statement)
        else
            -- ADD TO THE BEGINNING OF THE FILE
            vim.api.nvim_buf_set_lines(0, 0, 0, false, { import_statement, '' })
            print('Import added to the beginning of the file: ' .. import_statement)
        end
    end, { nargs = '?' })

    -- COMMAND TO SORT IMPORTS
    vim.api.nvim_create_user_command('PySortImports', function()
        -- VERIFY IF WE ARE IN A PYTHON BUFFER
        if vim.bo.filetype ~= 'python' then
            print('This command is designed for Python files. Current filetype: ' .. vim.bo.filetype)
            return
        end

        -- TRIGGER THE CODE ACTION FOR ORGANIZING IMPORTS
        vim.lsp.buf.code_action {
            context = {
                only = {
                    'source.organizeImports',
                    'quickfix.organizeImports',
                    'ruff.organizeImports',
                },
                diagnostics = {},
            },
        }
    end, {})

    -- COMMAND TO FIX ALL PROBLEMS
    vim.api.nvim_create_user_command('PyFixAll', function()
        -- VERIFY IF WE ARE IN A PYTHON BUFFER
        if vim.bo.filetype ~= 'python' then
            print('This command is designed for Python files. Current filetype: ' .. vim.bo.filetype)
            return
        end

        -- TRIGGER THE CODE ACTION FOR FIXING ALL PROBLEMS
        vim.lsp.buf.code_action {
            context = {
                only = {
                    'source.fixAll',
                    'quickfix.fixAll',
                    'ruff.fixAll',
                },
                diagnostics = {},
            },
        }
    end, {})

    -- COMMAND TO SHOW ALL CODE ACTIONS
    vim.api.nvim_create_user_command('PyCodeActions', function()
        -- VERIFY IF WE ARE IN A PYTHON BUFFER
        if vim.bo.filetype ~= 'python' then
            print('This command is designed for Python files. Current filetype: ' .. vim.bo.filetype)
            return
        end

        -- SHOW ALL CODE ACTIONS
        vim.lsp.buf.code_action()
    end, {})

    -- COMMAND TO DEBUG LSP ACTIONS
    vim.api.nvim_create_user_command('PyDebugLsp', function()
        -- VERIFY IF WE ARE IN A PYTHON BUFFER
        if vim.bo.filetype ~= 'python' then
            print('This command is designed for Python files. Current filetype: ' .. vim.bo.filetype)
            return
        end

        -- GET ACTIVE LSP CLIENTS
        local clients = vim.lsp.get_active_clients { bufnr = 0 }
        if #clients == 0 then
            print 'No LSP clients attached to this buffer'
            return
        end

        -- DISPLAY ACTIVE CLIENTS
        print 'Active LSP clients for this buffer:'
        for _, client in ipairs(clients) do
            print('- ' .. client.name .. ' (id: ' .. client.id .. ')')
        end

        -- GET CODE ACTIONS WITHOUT FILTER
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
end

return M

-- SWIFT LSP CONFIGURATION

local M = {}

-- EXPLICITLY DISABLE DOCUMENT HIGHLIGHTING FOR SWIFT FILES
local disable_highlight_for_swift = function()
    local group = vim.api.nvim_create_augroup("DisableSwiftHighlight", { clear = true })
    
    -- DISABLE THE HIGHLIGHT REQUESTS COMPLETELY FOR SWIFT FILES
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "swift" },
        callback = function()
            -- OVERRIDE THE DOCUMENT HIGHLIGHT FUNCTION TO DO NOTHING FOR SWIFT
            vim.lsp.buf.document_highlight = function() end
            vim.lsp.buf.clear_references = function() end
            
            -- ALSO DISABLE ANY AUTOMATIC HIGHLIGHTS
            if vim.b.document_highlight_timer then
                vim.loop.timer_stop(vim.b.document_highlight_timer)
                vim.b.document_highlight_timer = nil
            end
        end,
        group = group,
    })
end

-- OPTION TO DISABLE DIAGNOSTICS FOR SWIFT FILES
-- SET THIS TO TRUE TO HIDE ALL ERROR MESSAGES IN CODE
local DISABLE_SWIFT_DIAGNOSTICS = true -- ENABLED BY DEFAULT TO HIDE ERRORS

-- AGGRESSIVELY DISABLE ALL DIAGNOSTICS FOR SWIFT FILES
local function aggressively_disable_swift_diagnostics()
    local group = vim.api.nvim_create_augroup("DisableSwiftDiagnostics", { clear = true })
    
    -- IMMEDIATELY DISABLE FOR CURRENT SWIFT FILES
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(bufnr) then
            local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
            if ft == "swift" then
                vim.diagnostic.reset(nil, bufnr)
                vim.diagnostic.disable(bufnr)
            end
        end
    end
    
    -- DISABLE FOR ALL FUTURE SWIFT FILES
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "swift" },
        callback = function(args)
            vim.diagnostic.reset(nil, args.buf)
            vim.diagnostic.disable(args.buf)
            
            -- ALSO CLEAR ON TEXT CHANGE TO BE EXTRA SAFE
            vim.api.nvim_create_autocmd({"TextChanged", "TextChangedI"}, {
                buffer = args.buf,
                callback = function()
                    vim.diagnostic.reset(nil, args.buf)
                end
            })
        end,
        group = group,
    })
    
    -- OVERRIDE THE DIAGNOSTIC PUBLISH HANDLER TO PREVENT SWIFT DIAGNOSTICS
    local orig_handler = vim.lsp.handlers["textDocument/publishDiagnostics"]
    vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        local bufnr = vim.uri_to_bufnr(result.uri)
        
        -- ALLOW DIAGNOSTICS FOR NON-SWIFT FILES
        if vim.api.nvim_buf_is_valid(bufnr) then
            local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
            if ft ~= "swift" then
                return orig_handler(err, result, ctx, config)
            end
        end
        
        -- FOR SWIFT FILES, DON'T PROCESS DIAGNOSTICS
        return nil
    end
end

function M.setup(capabilities)
    -- CALL THE FUNCTION TO DISABLE HIGHLIGHTS FOR SWIFT FILES
    disable_highlight_for_swift()
    
    -- IMMEDIATELY DISABLE DIAGNOSTICS IF CONFIGURED
    if DISABLE_SWIFT_DIAGNOSTICS then
        aggressively_disable_swift_diagnostics()
    end

    -- MANUAL CONFIGURATION FOR SOURCEKIT-LSP (SWIFT)
    -- SOURCEKIT-LSP IS INSTALLED WITH XCODE ON MACOS AND IS NOT AVAILABLE VIA MASON
    if vim.fn.executable 'sourcekit-lsp' == 1 then
        -- DISABLE SEMANTIC TOKENS TO PREVENT FLASHING/FLICKERING
        local client_capabilities = vim.deepcopy(capabilities or {})
        client_capabilities.textDocument = client_capabilities.textDocument or {}
        client_capabilities.textDocument.semanticTokens = { dynamicRegistration = false }
        
        -- CORRECTLY STRUCTURE DOCUMENT HIGHLIGHT CAPABILITIES
        -- USE THE PROPER STRUCTURE INSTEAD OF BOOLEAN
        client_capabilities.textDocument.documentHighlight = {
            dynamicRegistration = false
        }
        
        -- DISABLE DIAGNOSTIC CAPABILITIES IF CONFIGURED
        if DISABLE_SWIFT_DIAGNOSTICS then
            client_capabilities.textDocument.publishDiagnostics = {
                dynamicRegistration = false
            }
        end

        require('lspconfig').sourcekit.setup {
            capabilities = client_capabilities,
            filetypes = { 'swift', 'objective-c', 'objective-cpp' },
            -- IMPROVED ROOT DIRECTORY DETECTION FOR BOTH SPM AND XCODE PROJECTS
            root_dir = require('lspconfig').util.root_pattern("Package.swift", "*.xcodeproj", "*.xcworkspace", ".git"),
            -- ADD INITIALIZATION OPTIONS TO IMPROVE FRAMEWORK DETECTION
            init_options = {
                enableSwiftBuildSupport = true,
                enableSwiftPMIntegration = true,
                diagnostics = {
                    -- SET TO TRUE TO DISABLE ERROR MESSAGES IN CODE
                    disabled = DISABLE_SWIFT_DIAGNOSTICS,
                },
            },
            -- ENSURE LSP WORKS WITH PROPER SDK DETECTION
            on_attach = function(client, bufnr)
                -- DISABLE ALL HIGHLIGHTING-RELATED CAPABILITIES
                if client.server_capabilities then
                    client.server_capabilities.documentHighlightProvider = false
                    client.server_capabilities.semanticTokensProvider = nil
                    
                    -- DISABLE DIAGNOSTICS PROVIDER IF CONFIGURED
                    if DISABLE_SWIFT_DIAGNOSTICS then
                        client.server_capabilities.diagnosticProvider = nil
                    end
                end
                
                -- DISABLE DIAGNOSTICS IF CONFIGURED
                if DISABLE_SWIFT_DIAGNOSTICS then
                    vim.diagnostic.disable(bufnr)
                    vim.diagnostic.reset(nil, bufnr)
                end
                
                -- DISABLE ANY HIGHLIGHT-RELATED COMMANDS FOR THIS BUFFER
                vim.api.nvim_buf_create_user_command(bufnr, "DocumentHighlight", function()
                    vim.notify("Document highlighting is disabled for Swift files", vim.log.levels.INFO)
                end, {})
                
                -- TRIGGER FULL DOCUMENT SYNC TO ENSURE PROPER INDEXING
                vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
                
                -- SET DIAGNOSTIC CONFIG
                vim.diagnostic.config({
                    update_in_insert = false,
                    underline = true,
                    virtual_text = { spacing = 4, prefix = "●" },
                    severity_sort = true,
                }, bufnr)
                
                -- PREVENT LSP FROM USING UNSUPPORTED METHODS
                vim.lsp.handlers["textDocument/documentHighlight"] = function()
                    -- DO NOTHING
                    return nil
                end
                
                -- ADD CUSTOM COMMAND TO TOGGLE DIAGNOSTICS
                vim.api.nvim_buf_create_user_command(bufnr, "ToggleSwiftDiagnostics", function()
                    local is_disabled = vim.diagnostic.is_disabled(bufnr)
                    if is_disabled then
                        vim.diagnostic.enable(bufnr)
                        vim.notify("Swift diagnostics enabled", vim.log.levels.INFO)
                    else
                        vim.diagnostic.disable(bufnr)
                        vim.diagnostic.reset(nil, bufnr)
                        vim.notify("Swift diagnostics disabled", vim.log.levels.INFO)
                    end
                end, {})
            end,
        }
    else
        vim.notify_once('sourcekit-lsp is not installed. For Swift, install Xcode and sourcekit-lsp.', vim.log.levels.WARN)
    end
end

return M

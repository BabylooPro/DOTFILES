-- SWIFT LSP CONFIGURATION

local M = {}

function M.setup(capabilities)
    -- MANUAL CONFIGURATION FOR SOURCEKIT-LSP (SWIFT)
    -- SOURCEKIT-LSP IS INSTALLED WITH XCODE ON MACOS AND IS NOT AVAILABLE VIA MASON
    if vim.fn.executable 'sourcekit-lsp' == 1 then
        require('lspconfig').sourcekit.setup {
            capabilities = capabilities,
            filetypes = { 'swift', 'objective-c', 'objective-cpp' },
        }
    else
        vim.notify_once('sourcekit-lsp is not installed. For Swift, install Xcode and sourcekit-lsp.', vim.log.levels.WARN)
    end
end

return M

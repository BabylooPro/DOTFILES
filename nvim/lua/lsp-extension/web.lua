-- WEB TECHNOLOGIES LSP CONFIGURATION (HTML, CSS, TAILWIND)

local M = {}

function M.setup(capabilities)
    -- CONFIGURATION FOR HTML
    require('lspconfig').html.setup {
        capabilities = capabilities,
        filetypes = { 'html', 'twig', 'hbs' },
    }

    -- CONFIGURATION FOR CSS
    require('lspconfig').cssls.setup {
        capabilities = capabilities,
    }

    -- CONFIGURATION FOR TAILWIND
    require('lspconfig').tailwindcss.setup {
        capabilities = capabilities,
        filetypes = { 'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
        init_options = {
            userLanguages = {
                razor = 'html',
            },
        },
    }
end

return M

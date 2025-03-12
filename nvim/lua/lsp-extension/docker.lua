-- DOCKER LSP CONFIGURATION

local M = {}

function M.setup(capabilities)
    -- CONFIGURATION FOR DOCKER
    require('lspconfig').dockerls.setup {
        capabilities = capabilities,
    }
end

return M

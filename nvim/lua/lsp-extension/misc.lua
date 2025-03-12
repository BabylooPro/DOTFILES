-- MISCELLANEOUS LSP CONFIGURATIONS (YAML, JSON, TERRAFORM, SQL)

local M = {}

function M.setup(capabilities)
    -- CONFIGURATION FOR YAML
    require('lspconfig').yamlls.setup {
        capabilities = capabilities,
    }

    -- CONFIGURATION FOR JSON
    require('lspconfig').jsonls.setup {
        capabilities = capabilities,
    }

    -- CONFIGURATION FOR TERRAFORM
    require('lspconfig').terraformls.setup {
        capabilities = capabilities,
    }

    -- CONFIGURATION FOR SQL
    require('lspconfig').sqlls.setup {
        capabilities = capabilities,
    }
end

return M

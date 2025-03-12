-- LSP EXTENSIONS MAIN MODULE
-- THIS FILE LOADS ALL LANGUAGE-SPECIFIC LSP CONFIGURATIONS

local M = {}

-- INITIALIZE ALL LANGUAGE-SPECIFIC LSP CONFIGURATIONS
function M.setup(capabilities)
    -- LOAD EACH LANGUAGE MODULE
    require('lsp-extension.csharp').setup(capabilities)
    require('lsp-extension.typescript').setup(capabilities)
    require('lsp-extension.python').setup(capabilities)
    require('lsp-extension.lua').setup(capabilities)
    require('lsp-extension.swift').setup(capabilities)
    require('lsp-extension.docker').setup(capabilities)
    require('lsp-extension.web').setup(capabilities) -- HTML, CSS, TAILWIND
    require('lsp-extension.misc').setup(capabilities) -- YAML, JSON, TERRAFORM, SQL
end

-- EXPORT UTILITY FUNCTIONS THAT MIGHT BE NEEDED ACROSS LANGUAGE MODULES
M.utils = {
    -- COMMON UTILITY FUNCTIONS HERE
}

return M

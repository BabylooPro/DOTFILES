-- LUA LSP CONFIGURATION

local M = {}

function M.setup(capabilities)
    -- CONFIGURATION FOR LUA_LS
    require('lspconfig').lua_ls.setup {
        capabilities = capabilities,
        settings = {
            Lua = {
                completion = {
                    callSnippet = 'Replace',
                },
                runtime = { version = 'LuaJIT' },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        '${3rd}/luv/library',
                        unpack(vim.api.nvim_get_runtime_file('', true)),
                    },
                },
                diagnostics = { disable = { 'missing-fields' } },
                format = {
                    enable = false,
                },
            },
        },
    }
end

return M

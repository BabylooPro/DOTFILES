-- ADVANCED DIAGNOSTICS CONFIGURATION
-- THIS FILE CONFIGURES THE DISPLAY OF ERRORS AND WARNINGS

-- MAIN DIAGNOSTICS CONFIGURATION
vim.diagnostic.config {
    -- DISPLAY OF VIRTUAL TEXT (INLINE ERROR MESSAGES)
    virtual_text = {
        severity = { min = vim.diagnostic.severity.ERROR },
        source = 'always',
        format = function(diagnostic)
            return string.format('[%s] %s', diagnostic.source, diagnostic.message)
        end,
    },

    -- OTHER OPTIONS
    signs = true, -- DISPLAY ICONS IN THE SIGN COLUMN
    underline = true, -- UNDERLINE ERRORS
    update_in_insert = true, -- UPDATE DIAGNOSTICS IN INSERT MODE
    severity_sort = true, -- SORT BY SEVERITY
    float = {
        border = 'rounded', -- BORDER STYLE FOR FLOAT WINDOW
        source = 'always', -- ALWAYS SHOW SOURCE
        header = '', -- NO HEADER
        prefix = '', -- NO PREFIX
    },
}

-- FORCE DIAGNOSTICS DISPLAY EVEN IN INSERT MODE
vim.api.nvim_create_autocmd({ 'InsertEnter', 'InsertLeave', 'BufEnter', 'BufWritePost' }, {
    pattern = '*',
    callback = function()
        vim.diagnostic.show()
    end,
})

-- GLOBAL KEYMAPS FOR DIAGNOSTICS
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic at cursor' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Add diagnostics to location list' })

-- INSERT MODE SHORTCUT TO DISPLAY DIAGNOSTICS
vim.keymap.set('i', '<C-e>', function()
    vim.cmd 'normal! <Esc>'
    vim.diagnostic.open_float()
    vim.cmd 'startinsert'
end, { desc = 'Show diagnostic in insert mode' })

-- AUTO-REFRESH LOCATION LIST WHEN DIAGNOSTICS CHANGE
vim.api.nvim_create_autocmd("DiagnosticChanged", {
  callback = function()
    -- CHECK IF LOCATION LIST IS OPEN BEFORE REFRESHING
    for _, win in pairs(vim.fn.getwininfo()) do
      if win.loclist == 1 then
        vim.diagnostic.setloclist()
        break
      end
    end
  end,
  desc = "AUTO-REFRESH LOCATION LIST WHEN DIAGNOSTICS CHANGE",
})

-- DIRECTLY INTERCEPT LSP DIAGNOSTICS
-- SAVE THE ORIGINAL FUNCTION
local original_publish_diagnostics = vim.lsp.handlers['textDocument/publishDiagnostics']

-- REPLACE WITH OUR CUSTOM FUNCTION
vim.lsp.handlers['textDocument/publishDiagnostics'] = function(err, result, ctx, config)
    -- CALL THE ORIGINAL FUNCTION
    original_publish_diagnostics(err, result, ctx, config)

    -- GET THE BUFFER CONCERNED
    local uri = result.uri
    local bufnr = vim.uri_to_bufnr(uri)

    -- FORCE IMMEDIATE DISPLAY OF DIAGNOSTICS
    vim.diagnostic.enable(bufnr)
    vim.diagnostic.show(nil, bufnr)

    -- FORCE DISPLAY AFTER A SHORT DELAY (FOR CASES WHERE LSP SENDS UPDATES)
    vim.defer_fn(function()
        if vim.api.nvim_buf_is_valid(bufnr) then
            vim.diagnostic.enable(bufnr)
            vim.diagnostic.show(nil, bufnr)
        end
    end, 100)

    -- AND AGAIN AFTER A LONGER DELAY
    vim.defer_fn(function()
        if vim.api.nvim_buf_is_valid(bufnr) then
            vim.diagnostic.enable(bufnr)
            vim.diagnostic.show(nil, bufnr)
        end
    end, 1000)
end

-- FORCE DIAGNOSTICS DISPLAY FOR ALL BUFFERS EVERY 2 SECONDS
local diagnostic_timer = vim.loop.new_timer()
if diagnostic_timer then
    diagnostic_timer:start(
        2000,
        2000,
        vim.schedule_wrap(function()
            for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].filetype == 'cs' then
                    vim.diagnostic.enable(bufnr)
                    vim.diagnostic.show(nil, bufnr)
                end
            end
        end)
    )

    -- ENSURE THE TIMER IS CLOSED WHEN NEOVIM CLOSES
    vim.api.nvim_create_autocmd('VimLeavePre', {
        callback = function()
            if diagnostic_timer then
                diagnostic_timer:close()
            end
        end,
    })
end

-- KEYMAPS CHEATSHEET MODULE --
-- DISPLAYS KEYMAPS.MD AS A FLOATING WINDOW --

local M = {}

-- FUNCTION TO DISPLAY KEYMAPS CHEAT SHEET IN A FLOATING WINDOW
function M.show_keymaps_cheatsheet()
  -- GET WORKSPACE DIRECTORY
  local nvim_config_dir = vim.fn.stdpath('config')
  local keymaps_file = nvim_config_dir .. '/KEYMAPS.md'
  
  -- READ THE KEYMAPS FILE
  local lines = {}
  local file = io.open(keymaps_file, 'r')
  if not file then
    vim.notify('Could not open KEYMAPS.md', vim.log.levels.ERROR)
    return
  end
  
  for line in file:lines() do
    table.insert(lines, line)
  end
  file:close()
  
  -- CREATE FLOATING WINDOW
  local width = math.min(120, vim.o.columns - 4)
  local height = math.min(50, vim.o.lines - 4)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  
  -- SET WINDOW OPTIONS
  local buf = vim.api.nvim_create_buf(false, true)
  local win_opts = {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
    title = 'NEOVIM KEYMAPS CHEAT SHEET',
    title_pos = 'center',
  }
  
  -- SET BUFFER CONTENT AND OPTIONS
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_open_win(buf, true, win_opts)
  
  -- SET BUFFER OPTIONS FOR MARKDOWN DISPLAY
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
  
  -- ADD KEYMAPS TO CLOSE THE WINDOW
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':q<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', ':q<CR>', { noremap = true, silent = true })
end

return M 

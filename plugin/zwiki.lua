-- You can use this loaded variable to enable conditional parts of your plugin.
if _G.ZwikiLoaded then
  return
end

_G.ZwikiLoaded = true

local M = {}

vim.api.nvim_create_user_command("Zwiki",
  ":lua require('zwiki').search()",
  { desc='Search Wiki' })
vim.api.nvim_create_user_command("ZwikiNew",
  ":lua require('zwiki').new(<q-args>, 0)",
  { desc='Search Wiki', nargs='?' })
vim.api.nvim_create_user_command("ZwikiTab",
  ":lua require('zwiki').new(<q-args>, 1)",
  { desc='Search Wiki', nargs='?' })
vim.api.nvim_create_user_command("ZwikiBacklink",
  ":lua require('zwiki').insert_backlinks()",
  { desc='Search Wiki' })

vim.keymap.set('n', '<leader>z', ':Zwiki<CR>', {})

local function autocmd_callback()
  local current_file = vim.api.nvim_buf_get_name(0)
  local options = require('zwiki').options
  if options and options.path and string.find(current_file, options.path) then
    return true
  end
  return false
end

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local current_file = vim.api.nvim_buf_get_name(0)
    if autocmd_callback() then
      vim.keymap.set('i', '[[', "<esc>:lua require('zwiki').link()<CR>", {buffer=true})
      vim.keymap.set('v', 'z', 'y:ZwikiTab<CR>p', {buffer=true})
      vim.keymap.set('n', '<CR>', require('zwiki').open_link, {buffer=true, silent=true})
    end
  end
})

vim.api.nvim_create_autocmd('BufWritePost', {
  callback = function()
    local current_file = vim.api.nvim_buf_get_name(0)
    if autocmd_callback() then
      vim.cmd('ZwikiBacklink')
    end
  end
})

return M

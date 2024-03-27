local M={}

local actions = require("fzf-lua.actions")
local utils   = require "fzf-lua.utils"
local path    = require("fzf-lua.path")

M.read_file = function(selected, opts)
  return actions.vimcmd_file("read", selected, opts)
end

M.create_link = function(selected, opts)
  local curbuf = vim.api.nvim_buf_get_name(0)
  local is_term = utils.is_term_buffer(0)
  local links = {}
  for i = 1, #selected do
    local entry = path.entry_to_file(selected[i], opts, opts.force_uri)
    local id = string.match(path.tail(entry.path), "(.+)%..+")
    local title = string.match(entry.stripped, ".+:%s+(.+)")
    table.insert(links, "[" .. title .. "](" .. id .. ")" )
  end
  vim.api.nvim_put({ table.concat(links, ", ") }, "", true, true)
  vim.api.nvim_feedkeys('a', 'n', false)
end

return M

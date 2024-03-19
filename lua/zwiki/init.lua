local M={}

local fzf = require('fzf-lua')
local default_actions = require("fzf-lua.actions")
local actions = require("zwiki.actions")

function M.search()
  return fzf.fzf_exec(
    vim.g.zwiki_default_source ,
    {
      prompt = 'ZWIKI> ',
      cwd = vim.g.zwiki_path,
      previewer = "builtin",
      exec_empty_query = true,
      actions = {
        ["default"] = default_actions.file_edit,
        ["ctrl-s"]  = default_actions.file_split,
        ["ctrl-v"]  = default_actions.file_vsplit,
        ["ctrl-t"]  = default_actions.file_tabedit,
        ["ctrl-r"]  = actions.read_file,
      },
    }
  )
end

function M.link()
  return fzf.fzf_exec(
    vim.g.zwiki_default_source ,
    {
      prompt = 'ZWIKI LINK> ',
      cwd = vim.g.zwiki_path,
      previewer = "builtin",
      exec_empty_query = true,
      actions = {
        ["default"] = actions.create_link,
      }
    }
  )
end

function M.new(cmd, tab)
  local fname = vim.g.zwiki_path .. os.date("%y%m%d-%H%M%S") .. vim.g.zwiki_ext
  local edit = tab ~= 0 and "tabe" or "e"
  vim.cmd(edit .. ' ' .. cmd .. ' ' .. fname)
end

return M

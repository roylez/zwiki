local M={}

local default_options = {
  path = nil,
  fzf_defaults = '--reverse --info inline -n 2..',
  ext = 'md'
}

local fzf = require('fzf-lua')
local default_actions = require("fzf-lua.actions")
local actions = require("zwiki.actions")

function M.defaults(options)
    M.options =
        vim.deepcopy(vim.tbl_deep_extend("keep", options or {}, default_options))
    return M.options
end

function M.setup(options)
  M.options = M.defaults(options or {})
  M.options.path = vim.fn.resolve(vim.fn.expand(M.options.path))
  return M.options
end

local function source_cmd()
  return [[gawk 'FNR < 8 && /^title:\s+/ {$1=""; print FILENAME":",$0; nextfile}' *.]] .. (M.options and M.options.ext or 'md')
end

function M.search()
  return fzf.fzf_exec(
    source_cmd(),
    {
      prompt = 'ZWIKI> ',
      cwd = M.options.path,
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
    source_cmd(),
    {
      prompt = 'ZWIKI LINK> ',
      cwd = M.options.path,
      previewer = "builtin",
      exec_empty_query = true,
      actions = {
        ["default"] = actions.create_link,
      }
    }
  )
end

function M.new(cmd, tab)
  local fname = vim.fn.resolve(M.options.path .. "/" .. os.date("%y%m%d-%H%M%S") .. '.' .. M.options.ext)
  local edit = tab ~= 0 and "tabe" or "e"
  vim.cmd(edit .. ' ' .. cmd .. ' ' .. fname)
end

function M.open_link()
  local col = vim.fn.col('.')
  local line = vim.fn.getline('.')
  local link = ""
  for i = col,1,-1 do
    link = line:match("%[.-%]%((.-)%)", i)
    if link then
      break
    end
  end
  if not link then return end
  if link:sub(-3,-1) == '.md' then
    vim.cmd("edit " .. link)
  else
    vim.cmd("edit " .. link .. ".md")
  end
end

function M.insert_backlinks()
  local content = vim.api.nvim_buf_get_lines(0, 0, -1, true)
  local title = nil
  for _, l in pairs(content) do
    if l:find("^title: ") then
      title, _ =l:gsub("^title: ", "")
      break
    end
  end
  if not title then return end
  vim.cmd [[
   let content       = join(getline(1, "$"), "\n")
   let current_fn_id = expand("%:t:r")
   let current_fn    = expand("%:t")
   let pattern       = '(\(.\{-}\)\(\.md\|\.wiki\)\?)'
   let title_pattern = '^title:\s\+\(.*\)$'
   let title_line_no = search(title_pattern)
   let title_line = getline( title_line_no )
   let title = substitute(title_line, title_pattern, '\=submatch(1)', 'n')
   let current_link = '[' . title . '](' . current_fn .')'
   let linked_files   = [ ]
   call substitute(content, pattern, '\=add(linked_files, submatch(1) . ".md")', 'g')
   call uniq(linked_files)
   call filter(linked_files, 'filereadable(v:val)')
   let unlinked = []
   for l in linked_files
      " not found in the target file and target file is not current file
      let link_file_conent = readfile(l)
      if match(link_file_conent, printf('(%s\(\.md\|\.wiki\)\?)', current_fn_id)) == -1 && l != current_fn
         echom "Adding Zettel link: " . l . ' -> ' . current_fn
         if match(link_file_conent, '^### LINKS') == -1
            call writefile(["", "### LINKS", ""], l, "a")
         endif
         call writefile(["* " . current_link ], l, "a")
      endif
   endfor
  ]]
end

return M

" ------------------------------------------------------------------------------
" Exit when your app has already been loaded (or "compatible" mode set)
if exists("g:loaded_zwiki") || &cp
  finish
endif
let g:loaded_zwiki = 1

let s:fzf_rg      = get(g:, 'fzf_rg', "rg --no-heading --color=always --smart-case ")
let s:fzf_rg_opts = get(g:, 'fzf_rg_opts', '-e --color '.&background. ' --no-hscroll --delimiter : --nth 3..')

" Global Maps:
"
" noremap <silent> <unique> <script> <Plug>AppFunction
" \ :set lz<CR>:call <SID>AppFunction()<CR>:set nolz<CR>
command! -nargs=? Znew      :call <sid>new_zettel(<q-args>, 0)
command! -nargs=? Ztab      :call <sid>new_zettel(<q-args>, 1)
command!          Z         :call <sid>fzf_search_zettel()
command!          Zlinks    :call <sid>fzf_get_local_link()
command!          Zbacklink :call <sid>insert_backlinks()

" ------------------------------------------------------------------------------

fun! s:new_zettel(cmd, tab)
  if a:tab == 1
    let l:e = ':tabe '
  else
    let l:e = ':e '
  endif
  execute l:e . a:cmd . ' ' . zwiki#new_file() 
endfun

fun! s:fzf_get_local_link()
  call fzf#run({
           \'source': <sid>get_links(),
           \'sink': function("s:zettel_follow_local_link"),
           \'options': '--margin 15%,0',
           \'dir': zwiki#path(),
           \'down':  10})
endfun

fun! s:fzf_search_zettel()
  call fzf#vim#grep(
        \ s:fzf_rg . '"^title:\s+" ',
        \ 0, fzf#vim#with_preview({'dir': zwiki#path(), 'options': s:fzf_rg_opts }), 0 )
endfun

function! s:zettel_follow_local_link(line)
   let lnk = split(a:line, ":")[0]
   call vimwiki#base#open_link(":e ", lnk)
endfunction

function! s:insert_backlinks()
   let current_fn_id = expand("%:t:r")
   let current_fn    = expand("%:t")
   let pattern       = '(\(.\{-}\)\(\.md\|\.wiki\)\?)'
   let content       = join(readfile(expand("%:t")), "\n")
   let title_pattern = '^title:\s\+\(.*\)$'
   let title_line_no = search(title_pattern) 
   let title_line = getline( title_line_no )
   let title = substitute(title_line, title_pattern, '\=submatch(1)', 'n') 
   if title == ''
     return 0
   endif
   let current_link = '[' . title . '](' . current_fn .')'
   let linked_files   = [ ]
   call substitute(content, pattern, '\=add(linked_files, submatch(1) . zwiki#ext())', 'g')
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
endfunction

function! s:get_links()
   let @l=""
   %s/\[.\{-}\](.\{-})/\=setreg('L',submatch(0) . "\n")/n
   let all_links = substitute(@l, '\[\(.\{-}\)\](\(.\{-}\)\(\.md\|\.wiki\)\?)', '\2:   \1', 'g')
   return split(all_links, "\n")
endfunction

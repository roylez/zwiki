" ------------------------------------------------------------------------------
" Exit when your app has already been loaded (or "compatible" mode set)
if exists("g:loaded_zwiki") || &cp
  finish
endif

let g:loaded_zwiki = 1

let g:zwiki_fzf_defaults = '--reverse --info inline -n 2..'
let g:zwiki_ext  = get(g:vimwiki_list[0], 'ext')
let g:zwiki_path = get(g:vimwiki_list[0], 'path')
let g:zwiki_default_source = 'awk ''FNR < 3 && /^title:\s+/ {$1=""; print FILENAME":",$0; nextfile}'' *' . g:zwiki_ext

" Global Maps:
"
command!          Zwiki         :call <sid>fzf_search_zettel()
command! -nargs=? ZwikiNew      :call <sid>new_zettel(<q-args>, 0)
command! -nargs=? ZwikiTab      :call <sid>new_zettel(<q-args>, 1)
command!          ZwikiLinks    :call <sid>fzf_get_local_link()
command!          ZwikiBacklink :call <sid>insert_backlinks()

nnoremap <Leader>z :Zwiki<CR>

augroup vimwiki.zwiki
   au!
   au FileType vimwiki inoremap <buffer> [[ <esc>:call zwiki#fzf_insert_link()<CR>'
   au FileType vimwiki nnoremap <buffer> <Leader>l :ZwikiLinks<CR>
   au FileType vimwiki vnoremap <buffer> z y:ZwikiTab<CR>p
augroup END

augroup zwiki
  au!
  autocmd BufWritePost ??????-*.md silent :ZwikiBacklink
augroup END
" 
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
  call fzf#run(fzf#wrap({
           \'source': <sid>get_links(),
           \'sink': function("s:zettel_follow_local_link"),
           \'options': '--prompt "ZWIKI Links> " ' . g:zwiki_fzf_defaults,
           \'dir': g:zwiki_path }))
endfun

fun! s:fzf_search_zettel()
  call fzf#run(fzf#wrap({
           \'source': g:zwiki_default_source,
           \'sink': function("s:zettel_follow_local_link"),
           \'options': '--prompt "ZWIKI> " ' . g:zwiki_fzf_defaults,
           \'dir': g:zwiki_path }))
endfun

function! s:zettel_follow_local_link(line)
   let file = split(a:line, ":")[0]
   call vimwiki#base#edit_file("tabe", file, '')
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
   call substitute(content, pattern, '\=add(linked_files, submatch(1) . g:zwiki_ext)', 'g')
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
   %s/\[[^\]]\{-}\](.\{-})/\=setreg('L',submatch(0) . "\n")/n
   let all_links = substitute(@l, '\[\(.\{-}\)\](\(.\{-}\)\(\.md\|\.wiki\)\?)', '\2:   \1', 'g')
   return split(all_links, "\n")
endfunction


fun! zwiki#path()
  return get(g:vimwiki_list[0], 'path')
endfun

fun! zwiki#ext()
  return get(g:vimwiki_list[0], 'ext')
endfun

fun! zwiki#new_file()
   return zwiki#path() . strftime("%y%m%d-%H%M%S") . zwiki#ext()
endfun

fun! zwiki#fzf_insert_link()
  call fzf#run({
        \ 'source': 'rg --no-heading --smart-case "^(#+|title:)\s+" ',
        \ 'sink': function('zwiki#make_note_link'),
        \ 'options': '--margin 15%,0',
        \ 'dir': zwiki#path(),
        \ 'down':  10})
endfun

" returned string: [Title](YYYYMMDD-HHMMSS)
fun! zwiki#make_note_link(l)
   let line  = split(a:l, ':')
   let id    = substitute(l:line[0], '^\(.*/\)\?\(.*\)\' . zwiki#ext(), '\2', 'g')
   let title = substitute(l:line[-1], '^\#*\s\+', '', 'g')
   let link  = "[" . title ."](". id .")"
   call setline('.', getline('.') . link )
   call cursor(line('.'), col('.') + len(link) )
   call feedkeys('a', 'n')
endfun


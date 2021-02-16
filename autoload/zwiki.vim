fun! zwiki#new_file()
   return g:zwiki_path . strftime("%y%m%d-%H%M%S") . g:zwiki_ext
endfun

fun! zwiki#fzf_insert_link()
  call fzf#run({
        \ 'source': g:zwiki_default_source,
        \ 'sink': function('zwiki#make_note_link'),
        \ 'options': '--prompt "INSERT LINK> " --info=inline',
        \ 'down': 10,
        \ 'dir': g:zwiki_path })
endfun

" returned string: [Title](YYYYMMDD-HHMMSS)
fun! zwiki#make_note_link(l)
   let line  = split(a:l, ':')
   let id    = substitute(l:line[0], '^\(.*/\)\?\(.*\)\' . g:zwiki_ext, '\2', 'g')
   let title = substitute(l:line[-1], '^\#*\s\+', '', 'g')
   let link  = "[" . title ."](". id .")"
   let @z = link
   norm "zp
   call feedkeys('a', 'n')
endfun


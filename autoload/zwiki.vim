
fun! zwiki#path()
  return get(g:vimwiki_list[0], 'path')
endfun

fun! zwiki#ext()
  return get(g:vimwiki_list[0], 'ext')
endfun

function! zwiki#new_file()
   return zwiki#path() . strftime("%y%m%d-%H%M%S") . zwiki#ext()
endfunction


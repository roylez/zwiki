" ------------------------------------------------------------------------------
" Exit when your app has already been loaded (or "compatible" mode set)
if exists("g:loaded_zwiki") || &cp
  finish
endif

let g:loaded_zwiki = 1

let g:zwiki_fzf_defaults = '--reverse --info inline -n 2..'
let g:zwiki_ext  = get(g:vimwiki_list[0], 'ext')
let g:zwiki_path = get(g:vimwiki_list[0], 'path')
let g:zwiki_default_source = 'gawk ''FNR < 3 && /^title:\s+/ {$1=""; print FILENAME":",$0; nextfile}'' *' . g:zwiki_ext

" Global Maps:
"
command!          Zwiki         :lua require('zwiki').search()
command! -nargs=? ZwikiNew      :lua require('zwiki').new(<q-args>, 0)
command! -nargs=? ZwikiTab      :lua require('zwiki').new(<q-args>, 1)
command!          ZwikiBacklink :lua require('zwiki').insert_backlinks()

nnoremap <Leader>z :Zwiki<CR>

augroup zwiki
  au!
  au FileType vimwiki inoremap <buffer> [[ <esc>:lua require('zwiki').link()<CR>'
  au FileType vimwiki vnoremap <buffer> z y:ZwikiTab<CR>p
  execute 'autocmd! BufWritePost ' . '*/??????-*' . g:zwiki_ext . ' ZwikiBacklink'
augroup END

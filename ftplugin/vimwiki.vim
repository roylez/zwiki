inoremap <silent> [[ <esc>:call zwiki#fzf_insert_link()<CR>'
nnoremap <Leader>f :Z<CR>
nnoremap <Leader>l :Zlinks<CR>
vnoremap z y:Ztab<CR>p

augroup zwiki
  au!
  autocmd BufWrite ??????-*.md silent :Zbacklink
augroup END


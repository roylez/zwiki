inoremap <silent> [[ <esc>:call zwiki#fzf_insert_link()<CR>'
nnoremap <Leader>l :Zlinks<CR>
nnoremap <Leader>z :Z<CR>
vnoremap z y:Ztab<CR>p

augroup zwiki
  au!
  autocmd BufWritePost ??????-*.md silent :Zbacklink
augroup END


inoremap <buffer> [[ <esc>:call zwiki#fzf_insert_link()<CR>'
nnoremap <buffer> <Leader>l :Zlinks<CR>
vnoremap <buffer> z y:Ztab<CR>p

augroup zwiki
  au!
  autocmd BufWritePost ??????-*.md silent :Zbacklink
augroup END


inoremap <buffer> [[ <esc>:call zwiki#fzf_insert_link()<CR>'
nnoremap <buffer> <Leader>l :Zlinks<CR>
vnoremap <buffer> z y:Ztab<CR>p

inoremap <buffer> <expr> [[ :call zwiki#fzf_complete_link()<CR>'

augroup zwiki
  au!
  autocmd BufWritePost ??????-*.md silent :Zbacklink
augroup END


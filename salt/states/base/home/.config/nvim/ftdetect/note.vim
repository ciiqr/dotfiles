" *.todo are my note syntax
au BufRead,BufNewFile *.todo set filetype=note
au BufRead,BufNewFile *.txt  set filetype=note

" *.txt fallback to note syntax
" au BufRead,BufNewFile *.txt  setfiletype note

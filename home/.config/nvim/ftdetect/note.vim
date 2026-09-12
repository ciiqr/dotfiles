augroup NoteFileType
    " prevent duplicate auto commands
    autocmd!
    " auto set file type for txt/todo files
    autocmd BufRead,BufNewFile *.txt,*.todo setlocal filetype=note
augroup END

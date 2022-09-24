" Quit when a syntax file was already loaded.
if exists("b:current_syntax")
    finish
endif

" NOTE: these are based on the monokai theme I'm using, won't look the same in other themes
" TODO: standardize tokens and simply provide overrides for themes I actually use

" # comment
syntax match prefixComment '^\s*#.*'
highlight link prefixComment Comment

" x done
syntax match prefixDone '^\s*x\s\+.*'
highlight link prefixDone Function

" ? maybe / ~ partial
syntax match prefixMaybe '^\s*[\?~]\s\+.*'
highlight link prefixMaybe Identifier

" % section
syntax match prefixSection '^\s*%\s\+.*'
highlight link prefixSection String

" - todo
syntax match prefixTodo '^\s*-\s\+.*'
highlight link prefixTodo cssURL

" ! important
syntax match prefixImportant '^\s*!\s\+.*'
highlight link prefixImportant Keyword

" !! urgent
syntax match prefixUrgent '^\s*!!\s\+.*'
highlight link prefixUrgent ErrorMsg

" Quit when a syntax file was already loaded.
if exists("b:current_syntax")
    finish
endif

" NOTE: these are designed around monokai/dracula style themes, you'll likely
" want to customize the Note* highlights in your theme

" # comment
syntax match NoteComment '^\s*\zs#.*'
highlight link NoteComment Comment

" % section
syntax match NoteSection '^\s*\zs%\s\+.*'
highlight link NoteSection String

" x done
syntax match NoteDone '^\s*\zsx\s\+.*'
highlight link NoteDone Function

" - todo
syntax match NoteTodo '^\s*\zs-\s\+.*'
highlight link NoteTodo @variable.parameter

" ? question
syntax match NoteQuestion '^\s*\zs?\s\+.*'
highlight link NoteQuestion Identifier

" ~ partial
syntax match NotePartial '^\s*\zs\~\s\+.*'
highlight link NotePartial Identifier

" ! important
syntax match NoteImportant '^\s*\zs!\s\+.*'
highlight link NoteImportant Keyword

" !! urgent
syntax match NoteUrgent '^\s*\zs!!\s\+.*'
highlight link NoteUrgent ErrorMsg

" TODO: investigate proper code blocks, which match arbitrary languages
" code blocks
syntax region NoteCodeBlock
      \ start=/^\s*```\S*$/
      \ end=/^\s*```$/
      \ keepend
      \ contains=NoteCodeFence

syntax match NoteCodeFence /^\s*```\S*$/ contained
syntax match NoteCodeFence /^\s*```$/ contained

highlight default link NoteCodeBlock Text
highlight default link NoteCodeFence Comment

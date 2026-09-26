" Quit when a syntax file was already loaded.
if exists("b:current_syntax")
    finish
endif

" NOTE: the default groups are designed around monokai/dracula style themes,
" you'll likely want to customize the Note* highlights in your theme

" Scan 100-200 lines outside what's visible in order to ensure correct tokens
" are chosen (for note, only matters for code blocks)
syntax sync minlines=100 maxlines=200

" # comment
syntax match NoteComment '^\s*\zs#.*'
highlight default link NoteComment Comment

" % section
syntax match NoteSection '^\s*\zs%\s\+.*'
highlight default link NoteSection String

" x done
syntax match NoteDone '^\s*\zsx\s\+.*'
highlight default link NoteDone Function

" - todo
syntax match NoteTodo '^\s*\zs-\s\+.*'
highlight default link NoteTodo @variable.parameter

" ? question
syntax match NoteQuestion '^\s*\zs?\s\+.*'
highlight default link NoteQuestion Identifier

" ~ partial
syntax match NotePartial '^\s*\zs\~\s\+.*'
highlight default link NotePartial Identifier

" ! important
syntax match NoteImportant '^\s*\zs!\s\+.*'
highlight default link NoteImportant Keyword

" !! urgent
syntax match NoteUrgent '^\s*\zs!!\s\+.*'
highlight default link NoteUrgent ErrorMsg

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

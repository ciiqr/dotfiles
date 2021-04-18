call plug#begin(stdpath('data') . '/plugged')
    " ctrl + p: switch files
    Plug 'ctrlpvim/ctrlp.vim'

    " monokai colorscheme
    Plug 'dunckr/vim-monokai-soda'
call plug#end()

" auto install new plugins
" autocmd VimEnter * PlugInstall --sync +q | source $MYVIMRC

set number

colorscheme monokai-soda


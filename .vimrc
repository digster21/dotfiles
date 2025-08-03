set nocompatible " Disable Vi Compatibility 
set number " Show line numbers 
"set relativenumber " Show relative line numbers 
set tabstop=4 " Tab width
set shiftwidth=4 " Indent width
set expandtab " Use Spaces instead of tabs 
syntax on " Enable syntax hilighting

" Copy to clipboard and primary selection register. Depends on gvim.
vnoremap <C-c> "*y :let @+=@*<CR>

" Remap ESC for modes (insert, visual, select)
inoremap jk <Esc>
vnoremap jk <Esc>
snoremap jk <Esc>

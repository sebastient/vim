call pathogen#infect()

set expandtab ts=4 sts=4 sw=4
set cscopetag

syntax on
filetype plugin indent on

let g:SuperTabDefaultCompletionType = "context"
:let g:load_doxygen_syntax=1

nmap <C-@> :cs find s <C-R>=expand("<cword>")<CR><CR>

set cscopequickfix=s-,c-,d-,i-,t-,e-

cs add .


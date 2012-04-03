call pathogen#infect()

set noet ts=4 sts=4 sw=4 ai expandtab
set cscopetag

syntax on
filetype plugin indent on

let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabMappingForward="<C-@>"
let g:SuperTabMappingBackward="<S-C-@>"

let g:load_doxygen_syntax=1

let g:tagbar_width=60

let g:CCTreeKeyTraceForwardTree = '<C-\>]'
let g:CCTreeKeyTraceReverseTree = '<C-\>['

nmap ` :TagbarOpenAutoClose<CR>
nmap <C-@> :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap " :ShowMarksOnce<CR>

cs add .


call pathogen#infect()

if has("gui_running")
    colorscheme desert
endif

set noet ts=4 sts=4 sw=4 ai expandtab

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

"set cscopetag
set csto=0

if filereadable("cscope.out")
    cs add cscope.out
endif

set cscopeverbose

" The following maps all invoke one of the following cscope search types:
"
"   's'   symbol: find all references to the token under cursor
"   'g'   global: find global definition(s) of the token under cursor
"   'c'   calls:  find all calls to the function name under cursor
"   't'   text:   find all instances of the text under cursor
"   'e'   egrep:  egrep search for the word under cursor
"   'f'   file:   open the filename under cursor
"   'i'   includes: find files that include the filename under cursor
"   'd'   called: find functions that function under cursor calls

nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>  
nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>  
nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>  
nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>  
nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>  
nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>  
nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>


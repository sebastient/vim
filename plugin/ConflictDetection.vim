" ConflictDetection.vim: Detect and highlight SCM conflict markers.
"
" DEPENDENCIES:
"   - ConflictDetection.vim autoload script
"   - ingo/msg.vim autoload script
"   - ingo/search/timelimited.vim autoload script
"
" Copyright: (C) 2012-2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.12.006	26-Mar-2013	To avoid false positives (e.g. in nested email
"				replies), ensure that both "our" and "theirs"
"				markers do exist.
"				Use functions from ingo-library.
"   1.11.005	04-Dec-2012	FIX: Prevent error on Vim 7.0 - 7.2.
"   1.10.004	04-Dec-2012	ENH: Add :ConflictSyntax command.
"   1.02.003	16-Nov-2012	FIX: Avoid E417 / E421 in conflict marker
"				highlight group definitions when no original
"				color is defined (i.e. when the colorscheme does
"				not define a cterm / gui background color for
"				DiffAdd/Change/Text). Thanks to Dave Goodell for
"				sending a patch.
"   1.01.002	17-Oct-2012	Delegate search to
"				ingotimelimitedsearch#IsBufferContains() to
"				avoid long search delays on very large files.
"   1.00.001	12-Mar-2012	file creation

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_ConflictDetection') || (v:version < 700)
    finish
endif
let g:loaded_ConflictDetection = 1
let s:save_cpo = &cpo
set cpo&vim

"- configuration ---------------------------------------------------------------

if ! exists('g:ConflictDetection_AutoDetectEvents')
    let g:ConflictDetection_AutoDetectEvents = 'BufReadPost,BufWritePre'
endif
if ! exists('g:ConflictDetection_WarnEvents')
    let g:ConflictDetection_WarnEvents = 'BufReadPost,BufWritePost'
endif


"- functions -------------------------------------------------------------------

function! s:ConflictCheck()
    let l:conflictLnum = ingo#search#timelimited#IsBufferContains('^\([<=>|]\)\{7}\1\@!')
    if l:conflictLnum == 0
	let b:conflicted = 0
	return
    endif

    " To avoid false positives (e.g. in nested email replies), ensure that both
    " "our" and "theirs" markers do exist.
    let l:conflictType = strpart(getline(l:conflictLnum), 0, 1) " Dealing with pure ASCII characters.
    if l:conflictType ==# '<'
	let b:conflicted = !! ingo#search#timelimited#IsBufferContains('^\(>\)\{7}\1\@!', 0)
    elseif l:conflictType ==# '>'
	let b:conflicted = !! ingo#search#timelimited#IsBufferContains('^\(<\)\{7}\1\@!', 0)
    else
	let b:conflicted = (
	\   ingo#search#timelimited#IsBufferContains('^\(<\)\{7}\1\@!', 0) &&
	\   ingo#search#timelimited#IsBufferContains('^\(>\)\{7}\1\@!', 0)
	\)
    endif
endfunction
function! s:ConflictWarn()
    if ! exists('b:conflicted')
	call s:ConflictCheck()
    endif

    if b:conflicted
	call ingo#msg#WarningMsg('Conflict markers found')
    endif
endfunction
function! s:ConflictHighlight()
    if ! exists('b:conflicted')
	call s:ConflictCheck()
    endif

    if b:conflicted
	call ConflictDetection#Highlight()
    endif
endfunction


"- commands --------------------------------------------------------------------

if v:version < 703
command! -bar -nargs=?                  ConflictSyntax setlocal syntax=<args>|call ConflictDetection#Highlight()
else
command! -bar -nargs=? -complete=syntax ConflictSyntax setlocal syntax=<args>|call ConflictDetection#Highlight()
endif


"- autocmds --------------------------------------------------------------------

augroup ConflictDetection
    autocmd!
    if ! empty(g:ConflictDetection_AutoDetectEvents)
	execute 'autocmd' g:ConflictDetection_AutoDetectEvents '* call <SID>ConflictCheck()'
    endif
    if ! empty(g:ConflictDetection_WarnEvents)
	execute 'autocmd' g:ConflictDetection_WarnEvents '* call <SID>ConflictWarn()'
    endif

    autocmd BufReadPost,FileType * call <SID>ConflictHighlight()
augroup END


"- highlight groups ------------------------------------------------------------

highlight def link conflictOurs                     DiffAdd
highlight def link conflictBase                     DiffChange
highlight def link conflictTheirs                   DiffText
highlight def link conflictSeparatorMarkerSymbol    NonText

highlight def conflictSeparatorMarker   ctermfg=Grey guifg=Grey
function! s:GetColorDefinition( hlName, mode )
    let l:color = synIDattr(synIDtrans(hlID(a:hlName)), 'bg', a:mode)
    if empty(l:color) || l:color == -1
	" Avoid "E417: missing argument: guifg=" or "E421: Color name or number not recognized: ctermbg=-1"
	return ''
    endif

    return printf('%sfg=%s', a:mode, l:color)
endfunction
function! s:HighlightMarkerDefaultsLikeDiffHighlights()
    for [l:what, l:hlName] in [['Ours', 'DiffAdd'], ['Base', 'DiffChange'], ['Theirs', 'DiffText']]
	let l:colorDefinition = s:GetColorDefinition(l:hlName, 'cterm') . ' ' . s:GetColorDefinition(l:hlName, 'gui')
	if l:colorDefinition !=# ' '
	    execute printf('highlight def conflict%sMarker %s', l:what, l:colorDefinition)
	endif
    endfor
endfunction
if has('gui_running')
    autocmd GuiEnter * call <SID>HighlightMarkerDefaultsLikeDiffHighlights()
else
    call s:HighlightMarkerDefaultsLikeDiffHighlights()
endif

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :

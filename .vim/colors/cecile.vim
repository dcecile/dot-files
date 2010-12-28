" local syntax file - set colors on a per-machine basis:
" vim: tw=0 ts=4 sw=4
" Vim color file
" Maintainer:	Ron Aaron <ron@ronware.org>
" Last Change:	2003 May 02
" (Customized 'murphy')

hi clear
set background=dark
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "cecile"

" Default
hi Normal		guibg=#323232 guifg=#D3D7CF
hi Identifier	ctermfg=grey guifg=fg gui=none

" Comment
hi Comment		ctermfg=darkgreen guifg=#80FF80

" Type
hi Type			ctermfg=grey  guifg=#BFD9FF gui=none

" Keyword
hi Structure	ctermfg=darkcyan guifg=#C080FF gui=bold
hi Typedef  	ctermfg=darkcyan guifg=#C080FF gui=bold
hi Statement	ctermfg=darkcyan guifg=#C080FF gui=bold
hi Special		ctermfg=darkcyan guifg=#C080FF gui=bold
hi Todo			ctermfg=darkcyan guifg=#C080FF guibg=bg gui=bold
hi PreProc		ctermfg=darkcyan guifg=#C080FF gui=none
hi Operator 	ctermfg=darkcyan guifg=#C080FF gui=none
"hi xmlTag     	ctermfg=darkcyan guifg=#C080FF gui=none
"hi xmlEndTag  	ctermfg=darkcyan guifg=#C080FF gui=none
"hi xmlTagName  	ctermfg=darkcyan guifg=#C080FF gui=none

" Constant
hi Constant		ctermfg=darkmagenta guifg=#FF00BF gui=none
hi schemeError	ctermfg=darkmagenta guifg=#FF00BF gui=none
hi pythonBuiltinObj	ctermfg=darkmagenta guifg=#FF00BF gui=none

" Cursor stuff
hi Cursor		guifg=bg guibg=#AFB2AC
hi CursorLine   cterm=none ctermbg=darkgrey guibg=#4D4D4D
hi Search		guifg=White guibg=#544172
hi IncSearch	gui=reverse
hi Visual		guifg=bg guibg=fg

" Vim styles
hi Error		guibg=#8D2C3B guifg=White
hi Directory	guifg=fg
hi ErrorMsg		guibg=Red guifg=White
hi LineNr		ctermfg=darkblue guifg=#6C6E6A
hi ModeMsg		gui=bold
hi MoreMsg		gui=bold guifg=SeaGreen
hi NonText		ctermfg=darkblue gui=bold guifg=#6C6E6A
hi Question		gui=bold guifg=Cyan
hi SpecialKey	guifg=Cyan
hi StatusLine	ctermbg=black gui=none guifg=fg guibg=#090909
hi StatusLineNC ctermbg=darkgrey gui=none guifg=fg guibg=#232323
hi VertSplit    ctermbg=darkgrey gui=none guifg=fg guibg=#232323
hi Title		gui=bold guifg=Pink
hi WarningMsg	guifg=Red
hi Ignore       guifg=bg
hi MatchParen   guifg=fg guibg=#4D4D4D gui=bold,italic
hi Folded       guibg=bg guifg=Cyan

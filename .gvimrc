" No menubar
set guioptions=aegirL

" Menubar hide and show controls
nnoremap <F9> :set guioptions+=mT<CR>
nnoremap <S-F9> :set guioptions-=mT<CR>

" GUI font
if has("gui_win32")
    :set guifont=DejaVu_Sans_Mono:h10:cANSI
else
    :set guifont=DejaVu\ Sans\ Mono\ 10
endif

" Bottom line has height 1
set cmdheight=1

" Highlight the current line
set cursorline

" Sane mouse cursors
set mouseshape=i-r:beam,s:updown,sd:udsizing,vs:leftright,vd:lrsizing,m:no,ml:up-arrow,v:arrow

" Correct background color
set background=dark

" Don't beep (needs to be set again for GUI)
set visualbell t_vb=

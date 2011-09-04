" Unicode files
set enc=utf-8

" Activate improved features
set nocompatible

" Windows only looks in 'vimfiles' by default
set runtimepath+=~/.vim

" Regular backspace
set backspace=indent,eol,start

" Smart search casing
set ignorecase
set smartcase

" Incremental searching
set incsearch

" Cool statusline
set statusline=%<%f\ %m%a%=%([%R%H%Y]%)\ %-19(%3l\ of\ %L,%c%)%P

" Highlight lines that are too long
"syn match Search /\.\%>72v/

" Always write (don't ask)
:au FocusLost * :silent! wa

" Save on quit
set autowriteall

" Spaces for tabs, 2 spaces by default
set softtabstop=2
set shiftwidth=2
set expandtab

" Only use 4 spaces for these files
au FileType cpp,cs,java,xml setlocal softtabstop=4 shiftwidth=4

" Don't highlight the current line for slow filetypes 
au FileType ruby,xml,tex setlocal nocursorline

" Custom syntax matching
au BufNewFile,BufRead *.ctn setf cottontail

" Background buffers
set hidden

" Line numbers
set nu

" Give verbose file completion, don't precomplete
set wildchar=<Tab> wildmenu wildmode=longest:full

" Map ,, to buffer explorer
nnoremap <silent> ,, :silent BufExplorer<CR>j

" Space scrolls like less
nnoremap <Space> <C-d>
nnoremap <S-Space> <C-u>

" Scroll when cursor reaches top or bottom
set scrolloff=2

" Always show info about the current file
set laststatus=2

" Focus follows mouse
set mousefocus

" Don't autocontinue comments
augroup vimrcEx 
au! 
au FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
augroup END 

" Manual block indentation (not syntax-triggered)
set autoindent

" Custom colours
syntax enable
colorscheme cecile

" Highlight searches
set hlsearch

" Compatible shell
set shell=/bin/bash

" Width fixing
nnoremap f mf{jv}k$:!fixwidth<CR>`f
vnoremap f :!fixwidth<CR>

" Line ending fixing
" :%s/\r//g | set ff=dos | w | e

" Supertab plugin
"so /usr/share/vim/plugin/supertab.vim

" Line wrap by words
" set linewrap

" yank/paste using X
" or use \"+y \"+p
"set clipboard=unnamed

" Search for selected text, forwards or backwards.
" http://vim.wikia.com/wiki/Search_for_visually_selected_text
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

" Python
let python_highlight_builtins=1

" Don't beep
set visualbell t_vb=

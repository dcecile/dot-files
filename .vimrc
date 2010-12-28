set enc=utf-8
set nocompatible

" Windows only looks in 'vimfiles' by default
set runtimepath+=~/.vim

" Regular backspace
set backspace=2

" Smart search casing
set ignorecase
set smartcase

" Incremental searching
set incsearch

" Cool statusline
set statusline=%<%f\ %m%a%=%([%R%H%Y]%)\ %-19(%3l\ of\ %L,%c%)%P

" Spaces for tabs
set softtabstop=4
set shiftwidth=4
set expandtab

" Background buffers
set hidden

" Line numbers
set nu

" Give verbose file completion
set wildchar=<Tab> wildmenu wildmode=full

" Map ,, to buffer explorer
nnoremap ,, :BufExplorer<CR>j

" Space scrolls like less
"nnoremap <Space> <C-d>

" Scroll when cursor reaches top or bottom
set scrolloff=2

" Always show info about the current file
set laststatus=2

" Focus follows mouse
set mousefocus

" Don't autocontinue comments
if has("autocmd") 
  augroup vimrcEx 
  au! 
  au FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
  augroup END 
endif

" Automatic indentation
" set autoindent

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

" Inspiration
" http://nerditya.com/code/guide-to-neovim/

" Help
" https://github.com/mhinz/vim-galore
" https://github.com/junegunn/vim-plug

" Packages
" (run :PlugInstall after changing)
call plug#begin()
  " Sensible defaults
  Plug 'tpope/vim-sensible'

  " Code completion
  Plug 'ervandew/supertab'

  " Buffer management
  Plug 'kien/ctrlp.vim'

  " Word variants
  Plug 'tpope/vim-abolish'

  " Status bar
  Plug 'vim-airline/vim-airline'

  " Color scheme
  Plug 'sjl/badwolf'
  Plug 'vim-airline/vim-airline-themes'

  " Prose editing
  Plug 'reedes/vim-pencil'
  Plug 'junegunn/goyo.vim'

  " Navigation
  Plug 'smoka7/hop.nvim'

  " Language support
  Plug 'digitaltoad/vim-pug'
  Plug 'posva/vim-vue'
  Plug 'strogonoff/vim-coffee-script'
  Plug 'tpope/vim-haml'
  Plug 'wavded/vim-stylus'
  Plug 'digitaltoad/vim-pug'
  Plug 'derekwyatt/vim-scala'
  Plug 'asciidoc/vim-asciidoc'
  Plug 'pangloss/vim-javascript'
  Plug 'mxw/vim-jsx'
  Plug 'wlangstroth/vim-racket'
  Plug 'wilbowma/scribble.vim', { 'branch': 'wilbowma-custom' }
  Plug 'ElmCast/elm-vim'
call plug#end()

" Keyboard optimization
noremap ; :
noremap Q @q
noremap <C-[> <ESC>
let mapleader="\<SPACE>"

" Tabs
set expandtab
set tabstop=2
set shiftwidth=2
autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=2 shiftwidth=2
autocmd BufNewFile,BufRead *.elm setlocal tabstop=4 shiftwidth=4

" UI
set number

" Navigation
nnoremap <C-j> <C-d>
vnoremap <C-j> <C-d>
nnoremap <C-k> <C-u>
vnoremap <C-k> <C-u>
nnoremap <C-h> ^
vnoremap <C-h> ^
nnoremap <C-l> $
vnoremap <C-l> $

lua << EOF
  local hop = require('hop')
  hop.setup {
    keys = 'etovxqpdygfblzhckisuran'
  }
EOF
nnoremap <Leader><SPACE> :HopWord<CR>
vnoremap <Leader><SPACE> :HopWord<CR>
nnoremap <Leader>j :HopVerticalAC<CR>
vnoremap <Leader>j :HopVerticalAC<CR>
nnoremap <Leader>k :HopVerticalBC<CR>
vnoremap <Leader>k :HopVerticalBC<CR>
nnoremap <Leader>h :HopAnywhereCurrentLineBC<CR>
vnoremap <Leader>h :HopAnywhereCurrentLineBC<CR>
nnoremap <Leader>l :HopAnywhereCurrentLineAC<CR>
vnoremap <Leader>l :HopAnywhereCurrentLineAC<CR>

" Language support
let g:elm_setup_keybindings = 0

" Code completion
set wildmode=longest,list

" Prose
if !exists('g:vscode')
  augroup pencil
    autocmd!
    autocmd FileType markdown call pencil#init({'wrap': 'soft'})
    autocmd FileType asciidoc call pencil#init({'wrap': 'soft'})
    autocmd FileType scribble call pencil#init({'wrap': 'soft'})
    autocmd FileType text call pencil#init()
  augroup END
  let g:goyo_width=80
  nnoremap <Leader>g :Goyo<CR>
endif

" Buffer management
set hidden
if !exists('g:vscode')
  nnoremap <Leader>o :CtrlP<CR>
  nnoremap <Leader><TAB> :CtrlPBuffer<CR>
  nnoremap <Leader>f :CtrlPMRUFiles<CR>
  nnoremap <Leader>, :bnext<CR>
  nnoremap <Leader>. :bprevious<CR>
  nnoremap <Leader>c :bwipeout<CR>
else
  nnoremap <Leader>c :Tabclose<CR>
endif

" Search
nnoremap <silent> <C-n> :nohlsearch<CR>
set ignorecase
set smartcase

" Comments
augroup vimrcEx 
  autocmd! 
  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o " Don't auto-continue comments
augroup END 

" Saving
:autocmd FocusLost * silent! wall
set backupcopy=yes
nnoremap <ENTER> :wall<CR>
if !exists('g:vscode')
  nnoremap <Leader>q :wqall<CR>
  nnoremap <Leader>Q :q!<CR>
endif
let g:elm_format_autosave = 1

" Copy/paste
vnoremap <Leader>y "+y
vnoremap <Leader>d "+d
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P
vnoremap <Leader>p "+p
vnoremap <Leader>P "+P

" Color scheme
if !exists('g:vscode')
  colorscheme badwolf
  let g:airline_theme='badwolf'
  set termguicolors
endif

" Special files
nnoremap <Leader>e :sp ~/.config/git/emoji<CR><C-w>J

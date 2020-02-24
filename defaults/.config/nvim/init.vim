
call plug#begin()

Plug 'preservim/nerdtree'
Plug 'easymotion/vim-easymotion'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'arcticicestudio/nord-vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'OmniSharp/omnisharp-vim'
Plug 'aklt/plantuml-syntax'
Plug 'pangloss/vim-javascript'
Plug 'arcticicestudio/nord-vim'
Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

call plug#end()

syntax on
filetype plugin indent on
let mapleader = ","
set modelines=0
set number 		" Show line numbers
set ruler 		" Show file stats
set visualbell		" Blink cursor on error (no audio beep)
set encoding=utf-8
set hidden 		" Allow hidden buffers
set laststatus=2 	" Show status bar
set showmode
set showcmd
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
set termguicolors

" EasyMotion stuff
let g:EasyMotion_do_mapping = 0 " Disable default mappings
nnoremap <space> <NOP>
nmap <space> <Plug>(easymotion-jumptoanywhere)
let g:EasyMotion_smartcase = 1
let g:EasyMotion_keys = 'hklyuiopnmqwertzxcvbasdjf'
let g:EasyMotion_re_anywhere = '\v' .
        \       '(<.|^$)' . '|' .
        \       '(_\zs.)' . '|' .
        \       '(#\zs.)'

" Omnisharp config
let g:OmniSharp_server_stdio = 1
let g:OmniSharp_server_display_loading = 1
let g:OmniSharp_highlight_types = 3
let g:OmniSharp_selector_ui = 'fzf'


" Cursor style
let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"

" Start NERDTree
autocmd VimEnter * NERDTree
" Jump to the main window.
autocmd VimEnter * wincmd p
" Auto close Nerdtree if its the only window left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree")
      \ && b:NERDTree.isTabTree()) | q | endif

" Split window
nmap ss :split<Return><C-w>w
nmap sv :vsplit<Return><C-w>w
" Move window
map s<left> <C-w>h
map s<up> <C-w>k
map s<down> <C-w>j
map s<right> <C-w>l
map sh <C-w>h
map sk <C-w>k
map sj <C-w>j
map sl <C-w>l
" Resize window
nmap <C-w><left> <C-w><
nmap <C-w><right> <C-w>>
nmap <C-w><up> <C-w>+
nmap <C-w><down> <C-w>-

" FzF
map <C-p> :Files<Return>

" Airline configuraiton
let g:airline#extensions#tabline#enabled = 1

" Color sheme
colorscheme nord
let g:spacegray_low_contrast = 1
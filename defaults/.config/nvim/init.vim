
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
Plug 'sheerun/vim-polyglot'
Plug 'joshdick/onedark.vim'
Plug 'dense-analysis/ale'

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
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
let g:airline#extensions#tabline#enabled = 1

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
filetype indent plugin on
let g:OmniSharp_server_stdio = 1
let g:OmniSharp_server_display_loading = 1
let g:OmniSharp_highlight_types = 3
let g:OmniSharp_selector_ui = 'fzf'
let g:OmniSharp_diagnostic_showid = 1
let g:OmniSharp_timeout = 5
set previewheight=5
let g:ale_linters = { 'cs': ['OmniSharp'] }

augroup omnisharp_commands
    autocmd!

    " Show type information automatically when the cursor stops moving.
    " Note that the type is echoed to the Vim command line, and will overwrite
    " any other messages in this space including e.g. ALE linting messages.
    autocmd CursorHold *.cs OmniSharpTypeLookup

    " The following commands are contextual, based on the cursor position.
    autocmd FileType cs nnoremap <buffer> gd :OmniSharpGotoDefinition<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fi :OmniSharpFindImplementations<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fs :OmniSharpFindSymbol<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fu :OmniSharpFindUsages<CR>

    " Finds members in the current buffer
    autocmd FileType cs nnoremap <buffer> <Leader>fm :OmniSharpFindMembers<CR>

    autocmd FileType cs nnoremap <buffer> <Leader>fx :OmniSharpFixUsings<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>tt :OmniSharpTypeLookup<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>dc :OmniSharpDocumentation<CR>
    autocmd FileType cs nnoremap <buffer> <C-\> :OmniSharpSignatureHelp<CR>
    autocmd FileType cs inoremap <buffer> <C-\> <C-o>:OmniSharpSignatureHelp<CR>

    " Navigate up and down by method/property/field
    autocmd FileType cs nnoremap <buffer> <C-k> :OmniSharpNavigateUp<CR>
    autocmd FileType cs nnoremap <buffer> <C-j> :OmniSharpNavigateDown<CR>

    " Find all code errors/warnings for the current solution and populate the quickfix window
    autocmd FileType cs nnoremap <buffer> <Leader>cc :OmniSharpGlobalCodeCheck<CR>
augroup END

" Contextual code actions (uses fzf, CtrlP or unite.vim when available)
nnoremap <Leader><Space> :OmniSharpGetCodeActions<CR>
" Run code actions with text selected in visual mode to extract method
xnoremap <C-.> :call OmniSharp#GetCodeActions('visual')<CR>

" Rename with dialog
nnoremap <Leader>nm :OmniSharpRename<CR>
nnoremap <F2> :OmniSharpRename<CR>
" Rename without dialog - with cursor on the symbol to rename: `:Rename newname`
command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

nnoremap <Leader>cf :OmniSharpCodeFormat<CR>

" Start the omnisharp server for the current solution
nnoremap <Leader>ss :OmniSharpStartServer<CR>
nnoremap <Leader>sp :OmniSharpStopServer<CR>

" Enable snippet completion
let g:OmniSharp_want_snippet=1

" Cursor style
let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"

" Auto close Nerdtree if its the only window left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree")
      \ && b:NERDTree.isTabTree()) | q | endif
let NERDTreeShowHidden=1
nmap <leader>bb :NERDTree<Return>
nmap <leader>bv :NERDTreeVCS<Return>

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
let $FZF_DEFAULT_COMMAND = 'find .'

" Airline configuraiton
let g:airline#extensions#tabline#enabled = 1

" Color sheme
colorscheme onedark
let g:spacegray_low_contrast = 1

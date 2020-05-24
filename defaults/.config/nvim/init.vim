
call plug#begin()

Plug 'preservim/nerdtree'
Plug 'easymotion/vim-easymotion'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'OmniSharp/omnisharp-vim'
Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'sheerun/vim-polyglot'
Plug 'joshdick/onedark.vim'
Plug 'dense-analysis/ale'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'frazrepo/vim-rainbow'
Plug 'universal-ctags/ctags'
Plug 'majutsushi/tagbar'
Plug 'rbgrouleff/bclose.vim'
Plug 'ivalkeen/nerdtree-execute'
Plug 'mhinz/neovim-remote'
Plug 'lervag/vimtex'
Plug 'puremourning/vimspector'

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
set number relativenumber
let g:airline#extensions#tabline#enabled = 1
let g:rainbow_active = 1
let g:python3_host_prog = "/usr/bin/python3"
set clipboard+=unnamedplus

" Configure automatic toggling of hybrid line numbers
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
augroup end

" Linting
let g:ale_fix_on_save = 1

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

" VimSpector
let g:vimspector_enable_mappings = 'HUMAN'

" Go to tab by number
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<cr>

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

    " Run tests
    autocmd FileType cs nnoremap <buffer> <leader>rt :OmniSharpRunTest<CR>

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

" Ignore certain warnings
let g:OmniSharp_diagnostic_overrides = {
\ 'CSE0003': { 'type': 'None'},
\ 'CC0038': {'type': 'None'},
\ 'CS1701': {'type': 'I'},
\ 'IDE0058': {'type': 'None'},
\ 'IDE0008': {'type': 'None'},
\ 'CC0045': {'type': 'I'},
\ 'CC0071': {'type': 'I'},
\ 'CC0003': {'type': 'W'},
\ 'CC0088': { 'type': 'None'},
\ 'RemoveUnnecessaryImportsFixable': {'type': 'I'}
\}

" Cursor style
let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"

"NERDTree
" Auto close Nerdtree if its the only window left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree")
      \ && b:NERDTree.isTabTree()) | q | endif
let NERDTreeShowHidden=1
nmap <leader>bb :NERDTree<Return>
nmap <leader>bv :NERDTreeVCS<Return>
nnoremap <silent> <leader>bf :NERDTreeFind<CR>
let NERDTreeAutoDeleteBuffer = 1

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
map si <C-w>+
map su <C-w>-
" Resize window
nmap <C-w><left> <C-w><
nmap <C-w><right> <C-w>>
nmap <C-w><up> <C-w>+
nmap <C-w><down> <C-w>-

" Misc Keybindings
nmap t o<Esc>
nmap T O<Esc>
map <F1> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
map <F4> :execute "vimgrep /" . expand("<cword>") . "/j **" <Bar> cw<CR>   " Search in files for word under cursor

" Terminal mode
:tnoremap <Esc> <C-\><C-n>
nmap <leader>nt ss:terminal<CR>20su
nmap <leader>q :Bclose<CR>

" Tagbar
nmap <F8> :TagbarToggle<CR>

" FzF
map <C-p> :Files<Return>
let $FZF_DEFAULT_COMMAND = 'find .'

" Git stuff
nmap <leader>gb :Gblame<CR>
nmap <leader>gs :G<CR>
nmap <leader>gp :Gpull<CR>
nmap <leader>gm :Gdiff<CR>

" Latex config
let g:vimtex_compiler_progname = 'nvr'
let g:vimtex_view_general_viewer = 'zathura'
let g:vimtex_view_method = 'zathura'


nmap <leader>lc :VimtexCompile<CR>

" Airline configuraiton
let g:airline#extensions#tabline#enabled = 1

" Color sheme
colorscheme onedark

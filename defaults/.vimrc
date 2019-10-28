" Basic settings
set nocompatible
filetype off

" Load Plugin with Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'easymotion/vim-easymotion'
Bundle 'OmniSharp/omnisharp-vim'

call vundle#end()            " required

" Basic options
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

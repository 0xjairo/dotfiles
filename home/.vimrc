set shell=bash
call plug#begin('~/.vim/plugged')

" github repos
""""""""""""""
" Neomake
Plug 'benekastah/neomake'

" ctrlp
Plug 'ctrlpvim/ctrlp.vim'
let g:ctrlp_working_path_mode = 'wa' " start from CWD

"EditorConfig Vim Plugin
Plug 'editorconfig/editorconfig-vim'
" exclude changing these files
let g:EditorConfig_exclude_patterns = ['*.vhd']

" tpope plugins
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }
Plug 'majutsushi/tagbar'

Plug 'bling/vim-airline'

" Show changes
Plug 'mhinz/vim-signify'
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#whitespace#show_message = 0
let g:airline#extensions#syntastic#enabled = 0
let g:airline#extensions#branch#displayed_head_limit = 10
let g:airline#extensions#branch#format = 2

" colorschemes
"Plug 'nanotech/jellybeans.vim', { 'on': []}
Plug 'altercation/vim-colors-solarized'
Plug 'gosukiwi/vim-atom-dark'
Plug 'tomasr/molokai'
Plug 'morhetz/gruvbox'

"syntax additions
""""""""""""""""""
Plug 'srec.vim'
Plug 'digitaltoad/vim-jade'

Plug 'scrooloose/syntastic'

"Silver Searcher (silver-searcher-ag)
Plug 'rking/ag.vim'

Plug 'stephpy/vim-yaml'

" finally
"""""""""
call plug#end()

source ~/dotfiles/vim/vimrc.vim

set nocompatible    " vim
call plug#begin('~/.vim/plugged')

" To use powerline as installed with pip
"   pip install --user git+git://github.com/Lokaltog/powerline
"set rtp+=~/.local/lib/python2.7/site-packages/powerline/bindings/vim/

" github repos
""""""""""""""
" Neomake
Plug 'benekastah/neomake'

" ctrlp
Plug 'kien/ctrlp.vim'

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

" colorschemes
"Plug 'nanotech/jellybeans.vim', { 'on': []}
Plug 'altercation/vim-colors-solarized'
Plug 'gosukiwi/vim-atom-dark'
Plug 'tomasr/molokai'

"syntax additions
""""""""""""""""""
Plug 'srec.vim'
Plug 'digitaltoad/vim-jade'

Plug 'scrooloose/syntastic'

"Silver Searcher (silver-searcher-ag)
Plug 'rking/ag.vim'

" finally
"""""""""
call plug#end()

source ~/dotfiles/vim/vimrc.vim

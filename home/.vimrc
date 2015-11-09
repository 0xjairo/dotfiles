set nocompatible    " vim
call plug#begin('~/.vim/plugged')

" To use powerline as installed with pip
"   pip install --user git+git://github.com/Lokaltog/powerline
"set rtp+=~/.local/lib/python2.7/site-packages/powerline/bindings/vim/

" github repos
""""""""""""""
" Neomake
Plug 'benekastah/neomake'
Plug 'junegunn/fzf', {'dir':'~/.fzf', 'do':'yes \| ./install' }

"EditorConfig Vim Plugin
Plug 'editorconfig/editorconfig-vim'

" tpope plugins
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }
Plug 'majutsushi/tagbar'

Plug 'bling/vim-airline'
"let g:airline_theme='solarized'
"let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#buffer_nr_show = 1

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
"Plug 'gregsexton/Muon', { 'on': []}
"Plug 'jpo/vim-railscasts-theme', { 'on': []}
"Plug 'junegunn/seoul256.vim', { 'on': []}

"syntax additions
""""""""""""""""""
Plug 'srec.vim'
Plug 'digitaltoad/vim-jade'

" YouCompleteMe and Syntastic
Plug 'Valloric/YouCompleteMe',
    \ { 'for': ['python', 'c', 'cpp'],
    \'do': './install.sh --clang-completer' }
Plug 'scrooloose/syntastic'

"Silver Searcher (silver-searcher-ag)
Plug 'rking/ag.vim'

" finally
"""""""""
call plug#end()

source ~/dotfiles/vim/vimrc.vim

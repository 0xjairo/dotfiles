" .nvimrc
set termguicolors

call plug#begin()

Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug 'neomake/neomake'

" neovim-qt shim plugin
Plug 'equalsraf/neovim-gui-shim'

" colorschemes
Plug 'morhetz/gruvbox'
Plug 'chriskempson/base16-vim'
Plug 'gosukiwi/vim-atom-dark'


call plug#end()

"force filetype based on filename/extension
au BufNewFile,BufRead *.cmd set filetype=asm
au BufNewFile,BufRead SConstruct,SConscript set filetype=python

let g:ycm_extra_conf_globlist = ['~/work/*','!~/*']

" use spaces instead of tabs
set tabstop=4
set shiftwidth=4
set expandtab
set nohlsearch " don't highlight search matches
set nowrap
set number
set cursorline
" show invisible characters
set listchars=tab:▸\ ,eol:¬,trail:·,space:·
set nolist " show tabs and trailing spaces
set hidden " allow switching out of unsaved buffers (and keeps undo when switching buffers)

set ignorecase
set smartcase

let mapleader=" "

" key remaps
nnoremap <c-p> :Files<CR>
nnoremap <Leader>p :Buffers<CR>
" trim trailing white space from lines in file
nnoremap <Leader>t :%s/\s\+$//e<CR>
nnoremap <silent> <Leader>ag :Ag <C-R><C-W><CR>
" jump-to definition
nnoremap <Leader>jd :YcmCompleter GoTo<CR>
" toggle hightlight search matches
nnoremap <Leader>h :set hlsearch!<CR>
" close buffer and keep window layout
nnoremap <Leader>d :b#<bar>:bd#<CR>
" 
nnoremap <Leader><Tab> :b#<CR>

set background=dark
colorscheme gruvbox

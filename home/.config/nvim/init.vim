"" .nvimrc
call plug#begin()

Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer' }
Plug 'vim-syntastic/syntastic'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" syntastic options
let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list=2

" neovim-qt shim plugin
Plug 'equalsraf/neovim-gui-shim'

" colorschemes
Plug 'morhetz/gruvbox'
Plug 'chriskempson/base16-vim'
Plug 'gosukiwi/vim-atom-dark'

" vimwiki
Plug 'vimwiki/vimwiki'

"status line
Plug 'itchyny/lightline.vim'

call plug#end()

"force filetype based on filename/extension
au BufNewFile,BufRead *.cmd set filetype=asm
au BufNewFile,BufRead *.cla set filetype=c
au BufNewFile,BufRead SConstruct,SConscript set filetype=python

" comment continuation in vhdl or when reflowing comments with gq
augroup vhdlsyntax
   autocmd!
   autocmd FileType,Syntax vhdl set formatoptions=tcorq comments+=:--!,b:--!,:--,b:--
augroup END

" options for plugin Valloric/YouCompleteMe
let g:ycm_extra_conf_globlist = ['~/Projects/*','~/work/*','!~/*']
let g:ycm_autoclose_preview_window_after_insertion = 1

" use spaces instead of tabs
set tabstop=4
set shiftwidth=4
set expandtab
set nohlsearch " don't highlight search matches
set nowrap
set number
" show invisible characters
set listchars=tab:▸\ ,eol:¬,trail:·,space:·
set nolist " show tabs and trailing spaces
set hidden " allow switching out of unsaved buffers (and keeps undo when switching buffers)
set scrolloff=5

set ignorecase
set smartcase
set clipboard+=unnamedplus

set grepprg=rg\ --vimgrep
set inccommand=split  " live :%s substitutioni preview in split
set mouse=a

" cmdline completion to complete as much as possible
set wildmode=longest,list,full
set wildmenu

" map the command :wq to :w to avoid accidentaly write-quits
" to write-quit use :x
cmap wq w

let mapleader=" "

" FZF key remaps
""""""""""""""""
nnoremap <c-p> :Files<CR>
nnoremap <Leader>p :Buffers<CR>
nnoremap <silent> <Leader>ag :Ag <C-R><C-W><CR>

" trim trailing white space from lines in file
nnoremap <Leader>t :%s/\s\+$//e<CR>
" jump-to definition
nnoremap <Leader>jd :YcmCompleter GoTo<CR>
" toggle hightlight search matches
nnoremap <Leader>h :set hlsearch!<CR>
" clear the search pattern(clears hlsearch)
nnoremap <Leader>c :let @/=""<CR>
" delete buffer
nnoremap <Leader>d :bd<CR>
" previous buffer
nnoremap <Leader><Tab> :b#<CR>
" cd to directory containing file
nnoremap <Leader>~ :cd %:p:h<CR>
" Wrap lines
set linebreak "wrap lines on word boundaries
nnoremap <Leader>r :set wrap!<CR>


command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \ 'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \ <bang>0 ? fzf#vim#with_preview('up:60%')
  \         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \ <bang>0)


" Status line
"""""""""""""
let g:lightline = {
    \ 'colorscheme': 'wombat',
    \ 'active': {
    \   'left': [ ['paste'],
    \             ['fugitive', 'readonly', 'relativepath', 'modified'] ],
    \   'right': [ ['lineinfo'] ],
    \ },
    \ 'component_function': {
    \       'modified': 'LightlineModified',
    \       'readonly': 'LightlineReadonly',
    \       'fugitive': 'LightlineFugitive'
    \  },
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '|', 'right': '|' }
    \ }

function! LightlineFugitive()
	if exists('*fugitive#head')
		let branch = fugitive#head()
        return branch !=# '' ? '↯ '.branch : ''
    endif
    return ''
endfunction

function! LightlineReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'RO' : ''
endfunction

function! LightlineModified()
    if &filetype == "help"
        return ""
    elseif &modified
        return "+"
    elseif &modifiable
        return ""
    else
        return ""
    endif
endfunction



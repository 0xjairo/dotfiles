"" .nvimrc
call plug#begin()

if has("nvim")
    Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer' }
endif
Plug 'vim-syntastic/syntastic'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'aklt/plantuml-syntax'
Plug 'fs111/pydoc.vim'

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

if has("nvim")
    set termguicolors
    "colorscheme base16-monokai
    set background=dark
    colorscheme gruvbox
else
    set background=dark
    colorscheme gruvbox
endif

"force filetype based on filename/extension
au BufNewFile,BufRead *.cmd set filetype=asm
au BufNewFile,BufRead *.cla set filetype=c
au BufNewFile,BufRead SConstruct,SConscript set filetype=python

" Highlight all instances of word under cursor, when idle.
" Useful when studying strange source code.
" Type z/ to toggle highlighting on/off.
nnoremap z/ :call AutoHighlightToggle()<CR>

let g:match_word_ena = v:false
function! ToggleMatchCurWord()
    if g:match_word_ena != v:true
        call MatchCurWord()
        let g:match_word_ena = v:true
    else
        match none
        let g:match_word_ena = v:false
    endif
endfunction

function! MatchCurWord()
    let l:curword =  escape(expand('<cword>'), '/\')
    exe printf('match IncSearch /\V\<%s\>/', l:curword)
    let @/=printf("\\<%s\\>", l:curword)
endfunction

let g:auto_hl_prev_search = ""
function! AutoHighlightToggle()
    if exists('#auto_highlight')
        au! auto_highlight
        augroup! auto_highlight
        echo 'Highlight current word: off'
        match none
        let @/=g:auto_hl_prev_search
        return 0
    else
        let g:auto_hl_prev_search = @/
        augroup auto_highlight
            autocmd!
            autocmd CursorMoved * call MatchCurWord()
        augroup end
        " call :match() once to trigger current word on enable
        call MatchCurWord()
        echo 'Highlight current word: ON'
        return 1
    endif
endfunction

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
set cursorline
set ignorecase
set smartcase

set grepprg=rg\ --vimgrep
if has("nvim")
    set clipboard+=unnamedplus
    set inccommand=split  " live :%s substitutioni preview in split
else
    set clipboard+=unnamed
    " vim only options
    set backupdir=~/.vim/backup//
    set directory=~/.vim/swap//
    set undodir=~/.vim/undo//
endif
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
nnoremap <Leader>b :Buffers<CR>
nnoremap <silent> <Leader>rg :Rg <C-R><C-W><CR>

" previous buffer
nnoremap <Leader><Tab> :b#<CR>
" cd to directory containing file
nnoremap <Leader>~ :cd %:p:h<CR>
" clear the search pattern(clears hlsearch)
nnoremap <Leader>c :let @/=""<CR>
" delete buffer
nnoremap <Leader>d :bd<CR>
" jump-to definition
nnoremap <Leader>jd :YcmCompleter GoTo<CR>
" toggle hightlight search matches
nnoremap <Leader>l :set hlsearch!<CR>
" toggle match current word
nnoremap <Leader>m :call ToggleMatchCurWord()<CR>
" trim trailing white space from lines in file
nnoremap <Leader>t :%s/\s\+$//e<CR>
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
set laststatus=2
let g:lightline = {
    \ 'colorscheme': 'seoul256',
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

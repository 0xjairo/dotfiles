"" .nvimrc
call plug#begin()

Plug 'neomake/neomake'
if has("win32")
    Plug '~/.fzf/'
else
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
endif
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'honza/vim-snippets'
Plug 'fs111/pydoc.vim'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-commentary'

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
Plug 'SirVer/ultisnips'
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" neovim-qt shim plugin
Plug 'equalsraf/neovim-gui-shim'

" colorschemes
Plug 'morhetz/gruvbox'
Plug 'chriskempson/base16-vim'
Plug 'gosukiwi/vim-atom-dark'

"status line
Plug 'itchyny/lightline.vim'

if has("nvim")
    if has("win32")
        " LanguageClient-neovim
        Plug 'autozimu/LanguageClient-neovim', {
            \ 'branch': 'next',
            \ 'do': 'powershell -executionpolicy bypass -File install.ps1',
            \ }
    else
        " LanguageClient-neovim
        Plug 'autozimu/LanguageClient-neovim', {
            \ 'branch': 'next',
            \ 'do': 'bash install.sh',
            \ }
    endif

    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    let g:LanguageClient_serverCommands = {
        \ 'cpp': ['clangd'],
        \ 'c': ['clangd'],
        \ 'python': ['~/.local/bin/pyls'],
        \ }

    if has("win32")
        let g:LanguageClient_serverStderr = 'C:\Temp\clangd.stderr'
    else
        let g:LanguageClient_serverStderr = '/tmp/clangd.stderr'
    endif

    let g:LanguageClient_loadSettings = 1 " Use an absolute configuration path if you want system-wide settings
    let g:LanguageClient_settingsPath = '~/.config/nvim/settings.json'
    set completefunc=LanguageClient#complete
    set formatexpr=LanguageClient_textDocument_rangeFormatting()

    nnoremap <silent> gh :call LanguageClient#textDocument_hover()<CR>
    nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
    nnoremap <silent> gr :call LanguageClient#textDocument_references()<CR>
    nnoremap <silent> gs :call LanguageClient#textDocument_documentSymbol()<CR>
    nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

    nnoremap <F5> :call LanguageClient_contextMenu()<CR>
endif

call plug#end()

let g:neomake_logfile = 'C:\temp\neomake.log'
if has("nvim")
    call deoplete#custom#source('LanguageClient',
                \ 'min_pattern_length',
                \ 2)
    " auto run linting in normal mode with nvim only (async not supported in vim 7.4)
    call neomake#configure#automake('w', 1000)
else
    " auto run linting on :write 
    call neomake#configure#automake('w')
endif

if has("gui_vimr")
    colorscheme base16-onedark
elseif has("nvim")
    set termguicolors
    colorscheme base16-monokai
else
    set background=dark
    colorscheme pablo "gruvbox
endif

"force filetype based on filename/extension
au BufNewFile,BufRead *.cmd set filetype=asm
au BufNewFile,BufRead *.cla set filetype=c
au BufNewFile,BufRead SConstruct,SConscript set filetype=python

" Highlight all instances of word under cursor, when idle.
" Useful when studying strange source code.
" Type z/ to toggle highlighting on/off.
nnoremap z/ :call AutoHighlightToggle()<CR>

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
   autocmd FileType,Syntax vhdl setlocal commentstring=--\ %s
augroup END

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
set nocursorline
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
nmap ; :Buffers<CR>
nnoremap <silent> <Leader>rg :Rg <C-R><C-W><CR>

" previous buffer
nnoremap <Leader><Tab> :b#<CR>
" cd to directory containing file
nnoremap <Leader>~ :cd %:p:h<CR>
" toggle cursorline
nnoremap <Leader>c :set cursorline!<CR>
" delete buffer
nnoremap <Leader>d :bd<CR>
" toggle hightlight search matches
nnoremap <Leader>l :set hlsearch!<CR>
" toggle match current word
nnoremap <Leader>m :call MatchCurWord()<CR>
nnoremap <Leader>M :match none<CR>
" cnext
nnoremap <Leader>n :cnext<CR>
" trim trailing white space from lines in file
nnoremap <Leader>t :%s/\s\+$//e<CR>
" Wrap lines
set linebreak "wrap lines on word boundaries
nnoremap <Leader>r :set wrap!<CR>

" FZF hotness
" Builds quickfix list (:copen) from selected FZF items
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'

let g:netrw_preview = 1 " preview file with 'p' in a direcetory listing
let g:netrw_liststyle = 3
let g:netrw_winsize = 20
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \ 'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \ <bang>0 ? fzf#vim#with_preview('up:60%')
  \         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \ <bang>0)


" Status line
"""""""""""""
let s:hidden_all = 0
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
    endif
endfunction
" shift-h to toggle hiding status bar
nnoremap <S-h> :call ToggleHiddenAll()<CR>

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

if has("nvim")
    tnoremap <Esc> <C-\><C-n>
    tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
    tnoremap <A-h> <C-\><C-N><C-w>h
    tnoremap <A-j> <C-\><C-N><C-w>j
    tnoremap <A-k> <C-\><C-N><C-w>k
    tnoremap <A-l> <C-\><C-N><C-w>l
    inoremap <A-h> <C-\><C-N><C-w>h
    inoremap <A-j> <C-\><C-N><C-w>j
    inoremap <A-k> <C-\><C-N><C-w>k
    inoremap <A-l> <C-\><C-N><C-w>l
    nnoremap <A-h> <C-w>h
    nnoremap <A-j> <C-w>j
    nnoremap <A-k> <C-w>k
    nnoremap <A-l> <C-w>l
endif

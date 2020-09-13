call plug#begin()
if has("win32")
    Plug 'junegunn/fzf'
else
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
endif
Plug 'junegunn/fzf.vim'
Plug 'cespare/vim-toml'
Plug 'GutenYe/json5.vim'
Plug 'SirVer/ultisnips'
Plug 'airblade/vim-gitgutter'
Plug 'equalsraf/neovim-gui-shim' " neovim-qt shim plugin
Plug 'honza/vim-snippets'
Plug 'itchyny/lightline.vim' "status line
Plug 'rust-lang/rust.vim'
Plug 'othree/xml.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-surround'

"" colorschemes
Plug 'chriskempson/base16-vim'
call plug#end()
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

if has("nvim")
    set termguicolors
    colorscheme base16-default-dark
else
    set background=dark
    colorscheme pablo
endif

"force filetype based on filename/extension
au BufNewFile,BufRead *.cmd set filetype=asm
au BufNewFile,BufRead *.cla set filetype=c
au BufNewFile,BufRead SConstruct,SConscript set filetype=python
au BufNewFile,BufRead *.xacro set filetype=xml
au FocusLost * :wa " save all files on focus out

" Highlight all instances of word under cursor, when idle.
" Useful when studying unfamiliar source code.
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

set autoread " reread changed files without asking
set autowrite " save before :next, :make, etc
set eol " add new line to the end of the file
set fileformats=unix,dos,mac " prefer unix over windows over OS 9 formats
set hidden " allow switching out of unsaved buffers (and keeps undo when switching buffers)
set ignorecase
set listchars=tab:▸\ ,eol:¬,trail:·,space:· " show invisible characters
set mouse=a
set nobackup
set nocursorline
set noerrorbells
set nohlsearch " don't highlight search matches
set nolist " don't show tabs and trailing spaces
set noswapfile
set nowrap
set nowritebackup
set number
set printoptions=paper:letter " :hardcopy options
set ruler " show line and column all th etime
set scrolloff=5
set shortmess+=c
set signcolumn=yes
set smartcase
set updatetime=300
set virtualedit=all " allow to edit past the end of the line, pads with spaces
set wildmode=longest,list,full " cmdline completion to complete as much as possible
set wildmenu

set grepprg=rg\ --vimgrep
if has("nvim")
    set inccommand=split  " live :%s substitutioni preview in split
    set title " show file title in toolbar
endif

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

if empty($FZF_DEFAULT_OPTS)
    let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'
endif

if empty($FZF_DEFAULT_COMMAND)
    let $FZF_DEFAULT_COMMAND = 'rg --files'
endif

let g:netrw_banner = 0 " hide banner
let g:netrw_browse_split = 4 " open files in previous window
let g:netrw_preview = 1 " preview file with 'p' in a direcetory listing
let g:netrw_liststyle = 3 " tree view
let g:netrw_winsize = 20 " width of netrw window (when opened with :Vexplore or :Sexplore

set noshowmode
set ruler
set laststatus=2
set noshowcmd

let g:lightline = {
    \ 'active': {
    \   'left': [ ['mode', 'paste'],
    \             ['gitbranch', 'readonly', 'relativepath', 'modified'] ],
    \   'right': [ ['lineinfo'],
    \              ['percent'],
    \              ['fileformat', 'fileencoding', 'filetype'] ],
    \ },
    \ 'component_function': {
    \       'modified': 'LightlineModified',
    \       'readonly': 'LightlineReadonly',
    \       'gitbranch': 'FugitiveHead'
    \  },
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '|', 'right': '|' }
    \ }

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

" terminal mappings
if has("nvim")
    " <ctrl>+r <reg>: paste-insert (pi) the contents of register <reg>
    tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
    tnoremap <C-[> <C-\><C-N>
    " <alt>+<letter>: navigate windows with hjkl  (<letter>) in terminal mode
    tnoremap <A-h> <C-\><C-N><C-w>h
    tnoremap <A-j> <C-\><C-N><C-w>j
    tnoremap <A-k> <C-\><C-N><C-w>k
    tnoremap <A-l> <C-\><C-N><C-w>l
    " <alt>+<letter>: navigate windows with hjkl  (<letter>) in insert mode
    inoremap <A-h> <C-\><C-N><C-w>h
    inoremap <A-j> <C-\><C-N><C-w>j
    inoremap <A-k> <C-\><C-N><C-w>k
    inoremap <A-l> <C-\><C-N><C-w>l
    " <alt>+<letter>: navigate windows with hjkl  (<letter>) in normal mode
    nnoremap <A-h> <C-w>h
    nnoremap <A-j> <C-w>j
    nnoremap <A-k> <C-w>k
    nnoremap <A-l> <C-w>l
endif

if has("win32")
    " AAAAAAGGGGGHHHHH
    nmap <C-z> <nop>

    " use powershell
    set shell=powershell.exe
    set shellquote=
    set shellpipe=|
    set shellxquote=|
    set shellcmdflag=-NoProfile\ -NoLogo\ -ExecutionPolicy\ RemoteSigned\ -Command
    set shellredir=\|\ Out-File\ -Encoding\ UTF8
endif

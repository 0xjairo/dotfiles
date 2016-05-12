" try doing :setlocal ff=unix if you can't source from ~/.vimrc
" else, try this:
" http://stackoverflow.com/questions/1031396/how-to-share-one-vimrc-file-among-multiple-clients
set ff=unix

" remap leader to , instead of default back-slash
let mapleader=" "

" ~/.vimrc
set nocompatible    " vim defaults (not vi)
set smartindent     " smart indent
if !has('nvim')
    set encoding=utf-8 " Necessary to show Unicode glyphs
endif

" splitting settings
set splitbelow " open new window below for sp
set splitright " open winndow on the right for vsp

set hidden " allow to switch buffers without first saving
set backspace=indent,eol,start " allow to backspace after insert, auto-indent and end-of-line (join line)
set incsearch " display search results as you type
set ignorecase " ignore case when searching
set smartcase " make search case insensitive unless there's uppercase chars in search string
set scrolloff=2 " number of lines to display before/after the cursor when at the top/bottom of window
set switchbuf=usetab,newtab " switch to existing tab if the buffer is open
set nowrap " dont wrap lines by defaul
set wildignore+=*.so,*.swp,*.pyc,*.ngc,*.o,*.obj
set wildmode=longest,list,full " tab-completion for open files a-la bash
set switchbuf-=newtab "dont' open new tab when reviewing quickfix window
set cursorline " highlight current line
set spelllang=en_us

" tab defaults
"""""""""""""""
"
" short hands
"     tabstop: ts, softtabstop: sts, shiftwidth: sw
"
" description
"     tabstop: width of tab character
"     shiwftwidth: number of spaces when indenting
"     expandtab: causes spaces to be used instead of tab characters
"     softtabstop: fine-tunes the amount of whitespace to be inserted
"
set tabstop=4
set shiftwidth=4
set expandtab
set softtabstop=4
set textwidth=0 " disable automatic word wrap


if has("autocmd")
    " Per :help autocmd
    " Remove ALL autocommands for the current group.
    autocmd!

    " enable filetype detection
    filetype on

    " set the present/current working directory (pwd) to
    " that of the current file per vim.wikia.com
    " http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file
    "autocmd BufEnter * silent! cd %:p:h

    augroup filetype
        " treat arduino files as c++
        autocmd BufNewFile,BufRead,BufEnter *.pde,*.ino setfiletype cpp
        "
        " treat arduino files as c++
        autocmd BufNewFile,BufRead,BufEnter *.proto setfiletype proto

        " treat .VHD as .vhd
        autocmd BufNewFile,BufRead,BufEnter *.VHD setfiletype vhdl
        "
        " treat SConstruct files as python
        autocmd BufNewFile,BufRead SConstruct,SConscript setfiletype python

    augroup end

    " set tabs based on filetypes (if supported)
    """"""""""""""""""""""""""""""""""""""""""""
    " Syntax of these languages is fussy over tbs vs spaces
    autocmd FileType vhdl setlocal ts=4 sts=4 sw=4 expandtab ignorecase
    autocmd FileType make setlocal ts=4 sts=4 sw=4 noexpandtab
    autocmd FileType python setlocal ts=4 sts=4 sw=4 expandtab
    autocmd FileType markdown setlocal ts=4 sts=4 sw=4 expandtab
    " for 'flowed' mail messages. see http://wcm1.web.rice.edu/mutt-tips.html
    autocmd FileType mail setlocal fo+=aw
    "" treat .md files as markdown
    autocmd FileType markdown setlocal wrap linebreak spell nolist textwidth=79 nocursorline
    " local LaTeX options (set textwidth to automatically wrap)
    autocmd FileType tex setlocal spell textwidth=79
    " local HTML options use tabs
    autocmd FileType html setlocal ts=4 sts=4 sw=4 noexpandtab
    " close tags automatically if you type  </first
    autocmd FileType html :iabbrev <buffer> </ </<C-X><C-O>

    "turn on loading plugin files for specific file types
    filetype plugin on

endif


set showmode        " show INSERT/VISUAL
if !has('nvim')
    set ttyfast         " better vim performance (not compatible with neovim)
endif
" set undofile        " Creates .un~ file to keep undo history even after close
set undolevels=1000
if has('nvim')
    set clipboard^=unnamedplus " neovim clipboard. Requires python-neovim and xclip or xset in Linux
else
    set clipboard^=unnamed  "Use system clipboard by default
                            "The caret puts unnamed first in the list,
                            "as oppose to +=, which appends to the end.
endif
" set title
" set ruler           " show ruler at the bottom of window (with line number)
" the statusline option below replaces ruler option above
"set statusline=[%02n]\ %F\ %(\[%M%R%H]%)%=\ [%02B]%y%4l,%2c%2V\ %P%*
set laststatus=2

" see :help smartindent
" Basically with smartindent turned no, any line that you type that starts
" with a # will move the cursor to the beginning of the line.  This prevents
" that.
inoremap # X#

" Use the same symbols as TextMate for tabstops and EOLs
" see http://vimcasts.org/episodes/show-invisibles/
set listchars=tab:▸\ ,eol:¬,trail:·
"set listchars=tab:\.\ ,trail:·
set list " show tabs and trailing spaces

" Leader mappings
"""""""""""""""""
nmap <Leader>h :set hlsearch!<CR>
" toggle cursorline
nmap <Leader>c :set cursorline!<CR>
" cd into current file's directory
nmap <Leader>~ :lcd %:p:h<CR>
" <t>rim trailing white space from lines in file
nmap <Leader>t :%s/\s\+$//e<CR>
" close buffer and keep window layout
nmap <Leader>d :b#<bar>:bd#<CR>

" disable 'help' (K)
map K <nop>
nnoremap <C-a> <nop>

" Make cursor move directly below the current colum on wrapped lines by
" default
nmap j gj
nmap k gk

" toggle buffers
noremap <C-g> :b#<CR>

" list of open buffers
nnoremap <silent> <Leader>p :CtrlPBuffer<CR>



" Filter Ag results within vim
" Ctrl-X, Ctrl-V, Ctrl-T to open in a new split, vertical split, tab
" respectively
" Ctrl-A to select all matches and list them in quickfix window
"   Ctrl-D to deselect all
" Ag without argument will list all the files
function! s:ag_to_qf(line)
  let parts = split(a:line, ':')
  return {'filename': parts[0], 'lnum': parts[1], 'col': parts[2],
        \ 'text': join(parts[3:], ':')}
endfunction

function! s:ag_handler(lines)
  if len(a:lines) < 2 | return | endif

  let cmd = get({'ctrl-x': 'split',
               \ 'ctrl-v': 'vertical split',
               \ 'ctrl-t': 'tabe'}, a:lines[0], 'e')
  let list = map(a:lines[1:], 's:ag_to_qf(v:val)')

  let first = list[0]
  execute cmd escape(first.filename, ' %#\')
  execute first.lnum
  execute 'normal!' first.col.'|zz'

  if len(list) > 1
    call setqflist(list)
    copen
    wincmd p
  endif
endfunction

" Ag word under cursor
nmap <Leader>g :Ag <C-r><C-w><CR>

" Ignore Q to enter "Ex mode"
nnoremap Q <nop>

" appereance
""""""""""""

if &t_Co > 2 || has('gui_running')
    set number          " show line numbers
    set hlsearch        " highlight all matched search items
    syntax on           " enable syntax highlighting
endif

nnoremap <a-j> <c-w>j
nnoremap <a-k> <c-w>k
nnoremap <a-h> <c-w>h
nnoremap <a-l> <c-w>l
vnoremap <a-j> <c-\><c-n><c-w>j
vnoremap <a-k> <c-\><c-n><c-w>k
vnoremap <a-h> <c-\><c-n><c-w>h
vnoremap <a-l> <c-\><c-n><c-w>l
inoremap <a-j> <c-\><c-n><c-w>j
inoremap <a-k> <c-\><c-n><c-w>k
inoremap <a-h> <c-\><c-n><c-w>h
inoremap <a-l> <c-\><c-n><c-w>l
cnoremap <a-j> <c-\><c-n><c-w>j
cnoremap <a-k> <c-\><c-n><c-w>k
cnoremap <a-h> <c-\><c-n><c-w>h
cnoremap <a-l> <c-\><c-n><c-w>l
if has('nvim')
  tnoremap <a-j> <c-\><c-n><c-w>j
  tnoremap <a-k> <c-\><c-n><c-w>k
  tnoremap <a-h> <c-\><c-n><c-w>h
  tnoremap <a-l> <c-\><c-n><c-w>l
  "au WinEnter term://* startinsert
endif

" Run truecolor neovim if running neovim, but only if true color is enabled
" via the environment variable, and also when not in a tmux sesssion
let nvim_truecolor= has('nvim') &&
            \$NVIM_TUI_ENABLE_TRUE_COLOR==1 &&
            \$TMUX==""

" If gvim is running
if has('gui_running') || nvim_truecolor

    " Set font dependong on OS
    if has("win32") || has("win16")
        " set showbreak=… " show ... on wrapped lines
        set gfn=Consolas:h10:cANSI " font
    else
        set gfn=Ubuntu\ Mono\ 11
    endif

    colorscheme atom-dark

    ""colorscheme jellybeans " dark theme
    "set background=dark
    "colorscheme solarized

    set guitablabel=%M%-0.20t " 20 characters max on tab label
    set guioptions+=T " no toolbar
    " set guioptions-=r " no scrollbar
    " set guioptions-=e " no 'gui' tabs
    "set guioptions-=m " no menu bar

    " == these are only applicable to the 'desert' theme ==
    " make gui-background color same as the text background.
    " highlight NonText guibg=grey20

    " make EOL character blend
    "highlight NonText guifg=grey40
    " make tab character blend
    "highlight SpecialKey guifg=grey40

    "set co=120          " width of window
    "set lines=60        " height of window

" no GUI running, aka running on the terminal
else

    set mouse=a
    if !has('nvim')
        set term=screen-256color
    endif
    " cygwin
    if &term == "win32"
        colorscheme vividchalk
    " if unix terminal
    else


        "" option 2.
        " set background=dark
        " colorscheme solarized

        "let g:rehash256=1
        "colorscheme molokai

        "colorscheme jellybeans
        "colorscheme railscasts

    endif

endif

" highlight characters over 80
" highlight OverLength ctermbg=darkred ctermfg=white guibg=#592929
" match OverLength /\%81v.\+/
" swap file (.swp) directories.  The two trailing slashes
" on (//) names the swap files with full path names.
" see :help dir
set dir=~/tmp//,/var/tmp//,/tmp//,.

" for github.com/majutsushi/tagbar
let g:tagbar_type_vhdl = {
    \ 'ctagstype': 'vhdl',
    \ 'kinds' : [
        \'d:prototypes',
        \'b:package bodies',
        \'e:entities',
        \'a:architectures',
        \'t:types',
        \'p:processes',
        \'f:functions',
        \'r:procedures',
        \'c:constants',
        \'T:subtypes',
        \'r:records',
        \'C:components',
        \'P:packages',
        \'l:locals',
        \'i:instances'
    \]
\}

" for YouCompleteMe
let g:ycm_extra_conf_globlist = ['~/workspace/*', '~/prj/*', '!~/*']
noremap <F3> :YcmCompleter GoToDefinitionElseDeclaration<CR>


"
" plugin specific
"""""""""""""""""
fun! PluginCustomizations()

    " if vim-session exists
    if exists(':SaveSession')
        let g:session_autosave = 'yes'
        let g:session_autoload = 'no'
        let g:session_default_to_last = 0
    endif

    " show tagbar
    if exists(':TagbarToggle')
        nmap <F8> :TagbarToggle<CR>
    endif

    " NERDTree
    if exists(':NERDTree')
        nmap <F4> :NERDTreeToggle<CR>

        " ignore pyc files and files ending in ~
        let NERDTreeIgnore=['\.pyc$', '\~$', '\.o$', '\.obj$']
    endif

endfun
autocmd VimEnter * call PluginCustomizations()

command! -nargs=0 Make
    \ | execute ':silent !tmux send-keys -t 1 Enter "scons" Enter'
    \ | execute 'redraw!'
nnoremap <Leader>m :Make<CR>

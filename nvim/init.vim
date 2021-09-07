call plug#begin()

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" nvim tree
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'"

" lsp
Plug 'neovim/nvim-lspconfig'

"colorscheme
Plug 'briones-gabriel/darcula-solid.nvim'
Plug 'rktjmp/lush.nvim'
Plug 'shaunsingh/moonlight.nvim'
Plug 'shaunsingh/nord.nvim'
Plug 'shaunsingh/solarized.nvim'

" status line
Plug 'nvim-lua/plenary.nvim'
Plug 'famiu/feline.nvim'
Plug 'lewis6991/gitsigns.nvim'

" treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" file viewer
Plug 'kyazdani42/nvim-tree.lua'

" completion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'

" other
Plug 'cespare/vim-toml'
Plug 'GutenYe/json5.vim'
Plug 'rust-lang/rust.vim'
Plug 'othree/xml.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-surround'

call plug#end()

"inoremap <silent><expr> <C-Space> compe#complete()
"inoremap <silent><expr> <CR>      compe#confirm('<CR>')
"inoremap <silent><expr> <C-e>     compe#close('<C-e>')
"inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
"inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })



" nvim-tree
nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>
let g:nvim_tree_ignore = [ '.git', 'node_modules', '.cache' ]
let g:nvim_tree_gitignore = 1
let g:nvim_tree_show_icons = {
    \ 'git': 0,
    \ 'folders': 1,
    \ 'files': 1,
    \ 'folder_arrows': 1,
    \ }
let g:nvim_tree_icons = {
    \ 'default': '',
    \ 'symlink': '',
    \ 'git': {
    \   'unstaged': "✗",
    \   'staged': "✓",
    \   'unmerged': "",
    \   'renamed': "➜",
    \   'untracked': "★",
    \   'deleted': "",
    \   'ignored': "◌"
    \   },
    \ 'folder': {
    \   'arrow_open': "+",
    \   'arrow_closed': "-",
    \   'default': "",
    \   'open': "",
    \   'empty': "",
    \   'empty_open': "",
    \   'symlink': "",
    \   'symlink_open': "",
    \   },
    \   'lsp': {
    \     'hint': "",
    \     'info': "",
    \     'warning': "",
    \     'error': "",
    \   }
    \ }


"colorscheme darcula-solid
colorscheme moonlight
set termguicolors

set number
set nohlsearch
set cursorline
" use spaces instead of tabs
set tabstop=4
set shiftwidth=4
set expandtab
set listchars=tab:▸\ ,eol:¬,trail:·,space:· " show invisible characters
set list

" from https://github.com/neovim/nvim-lspconfig#Keybindings-and-completion
lua << EOF
local lspconfig = require('lspconfig')

if not lspconfig.rust_hdl then
  require'lspconfig/configs'.rust_hdl = {
    default_config = {
      cmd = {"vhdl_ls"};
      filetypes = { "vhdl" };
      root_dir = function(fname)
        return lspconfig.util.root_pattern('vhdl_ls.toml')(fname)
      end;
      settings = {};
    };
  }
end

-- Use an on_attach function to only map the following keys 
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
--local servers = { "pyright", "rust_analyzer", "tsserver" }
local servers = { "clangd", "pylsp", "rust_hdl"}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup { on_attach = on_attach }
end

-- tree-sitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = { "javascript" }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = {}, --{ "c", "rust" },  -- list of language that will be disabled
  },
}

-- gitsigns
require('gitsigns').setup()

-- completion
local cmp = require'cmp'
cmp.setup {
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    })
  },
  sources = {
    { name = 'buffer' },
    { name = 'nvim_lsp' },
    { name = 'path' }
  }
}
EOF

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
set virtualedit=block " allow to edit past the end of the line, pads with spaces
set wildmode=longest,list,full " cmdline completion to complete as much as possible
set wildmenu

set grepprg=rg\ --vimgrep
set inccommand=split  " live :%s substitutioni preview in split
set title " show file title in toolbar

" map the command :wq to :w to avoid accidentaly write-quits
" to write-quit use :x
cmap wq w

let mapleader=" "

" FZF key remaps
""""""""""""""""
nnoremap <c-p> :Files<CR>
nmap ; :Buffers<CR>
nnoremap <silent> <Leader>rg :Rg <C-R><C-W><CR>
if has("win32")
    " Disable preview window
    let g:fzf_preview_window = []
endif

" previous buffer
nnoremap <Leader><Tab> :b#<CR>
" cd to directory containing file
nnoremap <Leader>~ :cd %:p:h<CR>
" toggle cursorline
nnoremap <Leader>c :set cursorline!<CR>
" delete buffer
nnoremap <Leader>d :b# <bar> :bd#<CR>
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
let g:netrw_liststyle = 3 " tree view

set noshowmode
set ruler
set laststatus=2
set noshowcmd

"" <ctrl>+r <reg>: paste-insert (pi) the contents of register <reg>
"tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'

" <ctrl>+[ for escape
"tnoremap <C-[> <C-\><C-N>

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

source ~/dotfiles/nvim/statusline.vim

local cmd = vim.cmd
local g = vim.g
local opt = vim.opt
local env = vim.env

g.mapleader = " "

opt.termguicolors = true
-- use spaces instead of tabs
opt.tabstop=4
opt.shiftwidth=4
opt.expandtab = true
--opt.listchars="tab:▸\ ,eol:¬,trail:·,space:·" -- show invisible characters
opt.list = true
-- Wrap lines
opt.linebreak = true -- wrap lines on word boundaries

opt.autoread = true -- reread changed files without asking
opt.autowrite = true -- save before :next, :make, etc
opt.eol = true -- add new line to the end of the file
opt.fileformats = 'unix,dos,mac' -- prefer unix over windows over OS 9 formats
opt.hidden = true -- allow switching out of unsaved buffers (and keeps undo when switching buffers)
opt.ignorecase = true
opt.listchars='tab:▸\\ ,eol:¬,trail:·,space:·' -- show invisible characters
opt.mouse='a'
opt.backup = false
opt.cursorline = false
opt.errorbells = false
opt.hlsearch = false -- don't highlight search matches
opt.list = false -- don't show tabs and trailing spaces
opt.swapfile = false
opt.wrap = false
opt.writebackup = false
opt.number = true
opt.printoptions = 'paper:letter' -- :hardcopy options
opt.ruler = true-- show line and column all th etime
opt.scrolloff = 5
opt.shortmess:append('c')
opt.signcolumn='yes'
opt.smartcase = true
opt.updatetime=300
opt.virtualedit='block' -- allow to edit past the end of the line, pads with spaces
opt.wildmode='longest,list,full' -- cmdline completion to complete as much as possible
opt.wildmenu=true
opt.splitright = true
opt.splitbelow = true

vim.cmd [[packadd packer.nvim]]
require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    -- " nvim tree
    use 'kyazdani42/nvim-web-devicons' -- for file icons
    use 'kyazdani42/nvim-tree.lua'
    use 'neovim/nvim-lspconfig'
    -- tree sitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    use 'nvim-telescope/telescope.nvim'
    -- status line
    use 'nvim-lua/plenary.nvim'
    use 'lewis6991/gitsigns.nvim'
    use 'nvim-lualine/lualine.nvim'

    -- completion
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/vim-vsnip'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-path'

    -- colorscheme
    use 'mhartington/oceanic-next'
    use 'bluz71/vim-moonfly-colors'

    -- git
    use 'tpope/vim-fugitive'
    use 'sindrets/diffview.nvim'
  end
)

vim.cmd 'colorscheme moonfly'

require'nvim-tree'.setup {
    filters = {
        custom = {'.git', 'node_modules', '.cache', 'build*/'}
    }
}



-- from https://github.com/neovim/nvim-lspconfig#Keybindings-and-completion
local lspconfig = require('lspconfig')

-- if not lspconfig.rust_hdl then
--   require'lspconfig/configs'.rust_hdl = {
--     default_config = {
--       cmd = {"vhdl_ls"};
--       filetypes = { "vhdl" };
--       root_dir = function(fname)
--         return lspconfig.util.root_pattern('vhdl_ls.toml')(fname)
--       end;
--       settings = {};
--     };
--   }
-- end

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
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setqflist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
--local servers = { "pyright", "rust_analyzer", "tsserver" }
--local servers = { "clangd", "pylsp", "rust_hdl", "rust_analyzer"}
local servers = { "clangd", "pylsp", "rust_analyzer", "tsserver"}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup { on_attach = on_attach }
end

-- tree-sitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = { "php", "tlaplus" }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = {}, --{ "c", "rust" },  -- list of language that will be disabled
  },
}

-- gitsigns
require('gitsigns').setup({
    current_line_blame = true
})

-- status line
require('lualine').setup({
  options = {
    component_separators = {'', ''},
    --section_separators = {'', ''},
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics'},
    lualine_c = {{'filename', path=1} },
    lualine_x = { 'encoding', 'fileformat', 'filetype'},
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
})

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

-- highlight on yank
vim.cmd([[au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_visual=true}]])

-- set filetype based on filename/extension
vim.cmd([[au BufNewFile,BufRead *.cmd set filetype=asm]])
vim.cmd([[au BufNewFile,BufRead *.cla set filetype=c]])
vim.cmd([[au BufNewFile,BufRead SConstruct,SConscript set filetype=python]])
vim.cmd([[au BufNewFile,BufRead *.xacro set filetype=xml]])
vim.cmd([[au FocusLost * :wa " save all files on focus out]])

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- windows only settings
if vim.fn.has('win32') == 1 then
    -- AAAAAAGGGGGHHHHH
    map('n', '<C-z>','<nop>')

    -- use powershell
    opt.shell = 'powershell.exe'
    opt.shellquote = ''
    opt.shellpipe = '|'
    opt.shellxquote = '|'
    opt.shellcmdflag='-NoProfile -NoLogo -ExecutionPolicy RemoteSigned -Command'
    opt.shellredir='| Out-File -Encoding UTF8'
end

map('n', ';', ':Telescope buffers<cr>')
map('n', '<C-p>', ':Telescope find_files<cr>')
map('n', '<leader>fg', ':Telescope live_grep<cr>')
map('n', '<leader>fh', ':Telescope help_tags<cr>')
map('n', '<leader>fl', ':Telescope git_branches<CR>')
map('n', '<leader>fc', ':Telescope git_commits<CR>')
map('n', '<leader>fs', ':Telescope lsp_document_symbols<CR>')
map('n', '<leader>rg', ':Telescope grep_string<CR>')

-- previous buffer
map('n', '<Leader><Tab>', ':b#<CR>')
-- toggle cursorline
map('n', '<Leader>c', ':set cursorline!<CR>')
-- delete buffer without closing window
map('n', '<Leader>d', ':b# <bar> :bd#<CR>')
-- toggle hightlight search matches
map('n', '<Leader>l', ':set hlsearch!<CR>')
-- cd to directory containing file
map('n', '<Leader>~', ':cd %:p:h<CR>')
-- cnext
map('n', '<Leader>n', ':cnext<CR>')
-- cprev
map('n', '<Leader>N', ':cprev<CR>')
-- trim trailing white space from lines in file
map('n', '<Leader>t', ':%s/\\s\\+$//e<CR>')
-- toggle line wrap
map('n', '<Leader>r', ':set wrap!<CR>')
-- nvim-tree
map('n', '<C-n>', ':NvimTreeToggle<CR>')

-- navigate windows with hjkl
-- in terminal mode
map('t', '<A-h>', '<C-\\><C-N><C-w>h')
map('t', '<A-j>', '<C-\\><C-N><C-w>j')
map('t', '<A-k>', '<C-\\><C-N><C-w>k')
map('t', '<A-l>', '<C-\\><C-N><C-w>l')
-- in insert mode
map('i', '<A-h>', '<C-\\><C-N><C-w>h')
map('i', '<A-j>', '<C-\\><C-N><C-w>j')
map('i', '<A-k>', '<C-\\><C-N><C-w>k')
map('i', '<A-l>', '<C-\\><C-N><C-w>l')
-- in normal mode
map('n', '<A-h>', '<C-w>h')
map('n', '<A-j>', '<C-w>j')
map('n', '<A-k>', '<C-w>k')
map('n', '<A-l>', '<C-w>l')


-- toggle virtual text (inline lsp diagnostics)
_G.lsp_diagnostics_enabled = true
_G.toggle_lsp_diagnostics_virtual_text = function()
    if _G.lsp_diagnostics_enabled then
        _G.lsp_diagnostics_enabled = false;
    else
        _G.lsp_diagnostics_enabled = true;
    end
    vim.diagnostic.config{virtual_text=_G.lsp_diagnostics_enabled}
end

-- cd to directory containing file
map('n', '<Leader>v', ':lua toggle_lsp_diagnostics_virtual_text()<CR>')

-- modified from
-- https://github.com/David-Kunz/vim/blob/f5e21eed15094532b07378ba3f76839ce3b1f37d/init.lua
_G.term_buf_of_tab = _G.term_buf_of_tab or {}
_G.term_buf_max_nmb = _G.term_buf_max_nmb or 0
_G.toggle_terminal = function()
  local cur_tab = vim.api.nvim_get_current_tabpage()
  local term_buf = term_buf_of_tab[cur_tab]
  if term_buf ~= nil and vim.api.nvim_buf_is_valid(term_buf) then
   local cur_buf = vim.api.nvim_get_current_buf()
   if cur_buf == term_buf then
     local splits = vim.api.nvim_tabpage_list_wins(0)
     -- only quit if this terminal is a split window
     if #splits > 1 then
         vim.cmd('q')
     end
   else
     vim.cmd('sb' .. term_buf)
     vim.cmd(':startinsert')
   end
  else
    vim.cmd('split | terminal')
    local cur_buf = vim.api.nvim_get_current_buf()
    _G.term_buf_max_nmb = _G.term_buf_max_nmb + 1
    vim.api.nvim_buf_set_name(cur_buf, "Terminal " .. _G.term_buf_max_nmb)
    table.insert(term_buf_of_tab, cur_tab, cur_buf)
    vim.cmd(':startinsert')
  end
end
map('n', '<a-`>', ':lua toggle_terminal()<CR>')
map('i', '<a-`>', '<ESC>:lua toggle_terminal()<CR>')
map('t', '<a-`>', '<c-\\><c-n>:lua toggle_terminal()<CR>')


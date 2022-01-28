local cmd = vim.cmd
local g = vim.g
local opt = vim.opt


g.mapleader = " "

opt.number = true
opt.hlsearch = false
opt.cursorline = true
-- use spaces instead of tabs
opt.tabstop=4
opt.shiftwidth=4
opt.expandtab = true
--opt.listchars="tab:▸\ ,eol:¬,trail:·,space:·" -- show invisible characters
opt.list = true

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
    use 'famiu/feline.nvim'
    use 'lewis6991/gitsigns.nvim'

    -- completion
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/vim-vsnip'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-path'

    -- colorscheme
    use 'mhartington/oceanic-next'
  end
)

vim.cmd 'colorscheme OceanicNext'

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
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
--local servers = { "pyright", "rust_analyzer", "tsserver" }
--local servers = { "clangd", "pylsp", "rust_hdl", "rust_analyzer"}
local servers = { "clangd", "pylsp", "rust_analyzer"}
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

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map('n', '<leader>ff', ':Telescope find_files<cr>')
map('n', '<leader>fg', ':Telescope live_grep<cr>')
map('n', '<leader>fb', ':Telescope buffers<cr>')
map('n', '<leader>fh', ':Telescope help_tags<cr>')
map('n', '<leader>fl', ':Telescope git_branches<CR>')
map('n', '<leader>fc', ':Telescope git_commits<CR>')
map('n', '<leader>fs', ':Telescope lsp_document_symbols<CR>')

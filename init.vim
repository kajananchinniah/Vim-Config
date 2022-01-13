" Install plugins
call plug#begin()
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'itchyny/lightline.vim'
  Plug 'preservim/nerdtree'
  Plug 'dense-analysis/ale'
  Plug 'lifepillar/vim-solarized8'
  Plug 'jreybert/vimagit'
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
call plug#end()

" Enable lightline
set laststatus=2
let g:lightline = {
\ 'colorscheme': 'solarized',
\ }


" LSP
lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
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
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'clangd' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }

require'nvim-treesitter.configs'.setup {
  -- One of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = "maintained",

  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- List of parsers to ignore installing
  ignore_install = { },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- list of language that will be disabled
    disable = { },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = true,
  },
}

end
EOF

"ALE

" Linters
let g:ale_linters = {
\ 'python': ['flake8', 'pylint'],
\ 'cpp': ['cc', 'ccls', 'clangcheck', 'clangtidy', 'clangd', 'clazy', 'cppcheck', 'cquery', 'flawfinder'],
\ 'cuda': ['clangd', 'nvcc'],
\ 'c': ['cc', 'ccls', 'clangd', 'clangtidy', 'cppcheck', 'cquery', 'flawfinder'],
\ 'cmake': ['cmakelint']
\}

" Fixers
let g:ale_fixers = {
\ '*': ['remove_trailing_lines', 'trim_whitespace'],
\ 'python': ['autoflake', 'autoimport', 'black', 'isort'],
\ 'cpp': ['clang-format'],
\ 'cuda': ['clang-format'],
\ 'c': ['clang-format'],
\ 'cmake': ['cmakeformat'],
\ 'rust': ['rustfmt'],
\}

" Style guide
let g:ale_c_clangformat_style_option= '{
\  BasedOnStyle: LLVM,
\  IndentWidth: 4,
\  BreakBeforeBraces: Linux,
\  AllowShortIfStatementsOnASingleLine: false,
\  IndentCaseLabels: false,
\}'

let g:ale_cpp_clangformat_style_option= '{
\  BasedOnStyle: LLVM,
\  IndentWidth: 4,
\  BreakBeforeBraces: Linux,
\  AllowShortIfStatementsOnASingleLine: false,
\  IndentCaseLabels: false,
\}'

let g:ale_cuda_clangformat_style_option= '{
\  BasedOnStyle: LLVM,
\  IndentWidth: 4,
\  BreakBeforeBraces: Linux,
\  AllowShortIfStatementsOnASingleLine: false,
\  IndentCaseLabels: false,
\}'

" C settings
let g:ale_c_clangformat_use_local_file=1
let g:ale_c_parse_compile_commands=1
let g:ale_c_clangd_executable='/usr/bin/clangd-10'
let g:ale_c_clangtidy_checks=[]
let g:ale_c_clangtidy_executable='/usr/bin/clang-tidy-10'
let g:ale_c_cppcheck_executable='/usr/bin/cppcheck'
let g:ale_c_clangformat_executable='/usr/bin/clang-format-10'

" C++ settings
let g:ale_cpp_clangformat_use_local_file=1
let g:ale_cpp_parse_compile_commands=1
let g:ale_cpp_clangcheck_executable='/usr/bin/clang-check-10'
let g:ale_cpp_clangd_executable='/usr/bin/clangd-10'
let g:ale_cpp_clangtidy_checks=[]
let g:ale_cpp_clangtidy_executable='/usr/bin/clang-tidy-10'
let g:ale_cpp_cppcheck_executable='/usr/bin/cppcheck'
let g:ale_cpp_clangformat_executable='/usr/bin/clang-format-10'

" CUDA settings
let g:ale_cuda_clangformat_use_local_file=1
let g:ale_cuda_clangd_executable='/usr/bin/clangd-10'
let g:ale_cuda_clangformat_executable='/usr/bin/clang-format-10'

" Other
let g:ale_set_balloons=1
let g:ale_linters_explicit=1
let g:airline#extensions#ale#enabled=1

let g:ale_lint_on_enter=0
let g:ale_fix_on_save=1

" Quick search for ALE errors
nmap <silent> <C-o> <Plug>(ale_previous_wrap)
nmap <silent> <C-p> <Plug>(ale_next_wrap)

"Solarized color scheme
set background=dark
colorscheme solarized8

" Prevent color scheme from changing background
autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE

" Hotkeys
map <C-o> :NERDTreeToggle<CR>
map <C-f> :Files<CR>

"Set UTF-8 encoding
set enc=utf-8
set fenc=utf-8
set termencoding=utf-8

"Disable vi compatibility
set nocompatible

" Use indentation of previous line
set autoindent

" Smart indentation
set smartindent

" Wrap line at 80 characters
set textwidth=80

" Syntax highlighting
set t_Co=256
syntax on

" Tab mapping; 4 spaces
filetype plugin indent on
" show existing tab with 2 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

" Show line numbers
set number

" Highlight matching braces
set showmatch

" Allow use of mouse
set mouse=r

" Vim-Plug - A Minimalist plugin manager
" The following plugins will be installed in the specified directory:
call plug#begin('~/.vim/plugged')
  " Maybe LSP configs?
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-lua/lsp_extensions.nvim'

  " Pasting in vim made a lot more convenient
  Plug 'roxma/vim-paste-easy' 

  " NERDTree is a godsend for big projects
  Plug 'scrooloose/nerdtree'

  " See which lines have been modified in a git-tracked project
  Plug 'airblade/vim-gitgutter'

  " Change working directory to project root when opening a file
  Plug 'airblade/vim-rooter'

  " A pretty status bar at the bottom of your vim
  Plug 'vim-airline/vim-airline'

  " FZF Integration
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'

call plug#end()

" GENERAL
syntax on  " Syntax highlighting on
set number " Show line numbers

" UNDO-ABILITY
set undodir=~/.undodir
set undofile

" SEARCH
set ignorecase
set smartcase

" TABS
set tabstop=2     " Show a tab as two spaces
set softtabstop=2 " When tab is pressed, insert two visual spaces
set expandtab     " Tabs aren't '\t' - they're spaces
set autoindent    " Try to handle indentation automatically

" KEYBINDINGS
let mapleader = "\<Space>"

inoremap jj <ESC><RIGHT>                   " Remap escape to 'jj'

nmap <leader>fs :w<CR>                     " Saves file 
nnoremap <leader><leader> <c-^>            " Switch to most recent buffer
nnoremap <leader>bp :bp<CR>                " Switch to previous buffer
nnoremap <leader>bn :bn<CR>                " Switch to next buffer
nnoremap <leader>< :Buffers<CR>            " List all currently open buffers
nnoremap <leader>ff :Files<CR>             " Search project files
nnoremap <leader>op :NERDTreeToggle<CR>    " Toggle project directory
nnoremap <leader>* :Rg<Space>

" From @jonhoo's config:
let g:fzf_layout = { 'down': '~20%' }
command! -bang -nargs=* Rg 
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

function! s:list_cmd()
  let base = fnamemodify(expand('%'), ':h:.:S')
  return base == '.' ? 'fd --type file --follow' : printf('fd --type file --follow | proximity-sort %s', shellescape(expand('%')))
endfunction

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, {'source': s:list_cmd(),
  \                               'options': '--tiebreak=index'}, <bang>0)

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
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'rust_analyzer', 'tsserver' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF

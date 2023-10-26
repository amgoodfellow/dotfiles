let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

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

" Remap escape to 'jj'
inoremap jj <ESC><RIGHT>

" Saves file
nmap <leader>fs :w<CR>
" Switch to most recent buffer
nnoremap <leader><leader> <c-^>
" Switch to previous buffer
nnoremap <leader>bp :bp<CR>
" Switch to next buffer
nnoremap <leader>bn :bn<CR>
" List all currently open buffers
nnoremap <leader>< :Buffers<CR>
" Search project files
nnoremap <leader>ff :Files<CR>
" Toggle project directory
nnoremap <leader>op :NERDTreeToggle<CR>
nnoremap <leader>/ :Rg<Space>

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


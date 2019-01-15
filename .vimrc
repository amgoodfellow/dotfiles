" Vim-Plug - A Minimalist plugin manager

" The following plugins will be installed in the specified directory:
call plug#begin('~/.vim/plugged')

  " Pasting in vim made a lot more convenient
  Plug 'roxma/vim-paste-easy' 

  " Tab completion for your favorite languages (just like an IDE)
  Plug 'Valloric/YouCompleteMe', { 'do': 'python3 ./install.py --clang-completer --js-completer --rust-completer --java-completer' }

  " NERDTree is a godsend for big projects
  Plug 'scrooloose/nerdtree'

  " See which lines have been modified in a git-tracked project
  Plug 'airblade/vim-gitgutter'

  " A pretty status bar at the bottom of your vim
  Plug 'vim-airline/vim-airline'

  " A live markdown preview will start in your browser
  Plug 'JamshedVesuna/vim-markdown-preview'

  " Latex + Vim = perfection
  Plug 'lervag/vimtex'

  " An AWESOME plugin for sending code to a REPL in a different window
  Plug 'jpalardy/vim-slime'

call plug#end()

" GENERAL
syntax on  " Syntax highlighting on
set number " Show line numbers

" TABS
set tabstop=2     " Show a tab as two spaces
set softtabstop=2 " When tab is pressed, insert two visual spaces
set expandtab     " Tabs aren't '\t' - they're spaces
set autoindent    " Try to handle indentation automatically

" REMAPS
inoremap jj <ESC><RIGHT> " Remap escape to 'jj'

" PLUGIN SPECIFIC
let g:python3_host_prog = '/usr/local/bin/python3'
let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": "default", "target_pane": "{right-of}"}

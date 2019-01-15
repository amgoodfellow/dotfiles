# System Variables -------------------------------------
export PATH="$HOME/.cargo/bin:$PATH"
HISTFILE=~/.histfile
HISTSIZE=8000
SAVEHIST=8000
# ------------------------------------------------------


##Prompt -----------------------------------------------
export PS1="%d  
>  "

#-------------------------------------------------------

# Configured by zsh-newuser-install
setopt autocd
bindkey -e

# The following lines were added by compinstall
zstyle :compinstall filename '/Users/aaron/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

##Sets up prompt and prompt plugins---------------------
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh


# User-defined functions--------------------------------

# Autorun exa on every cd
cd() {
  builtin cd "$@";
  exa;
}


# I can never remember the commands for different compressed files
# now I don't have to
extract () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2) tar xjf $1 ;;
      *.tar.gz) tar xzf $1 ;;
      *.bz2) bunzip2 $1 ;;
      *.rar) unrar e $1 ;;
      *.gz) gunzip $1 ;;
      *.tar) tar xf $1 ;;
      *.tbz2) tar xjf $1 ;;
      *.tgz) tar xzf $1 ;;
      *.zip) unzip $1 ;;
      *.Z) uncompress $1 ;;
      *.7z) 7z x $1 ;;
      *) echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# ------------------------------------------------------


# Alisases ---------------------------------------------
alias lll='exa --all'
alias pip='pip3'
alias ls='exa'
alias zshrc='source ~/.zshrc'
alias nvimrc='nvim ~/.config/nvim/init.vim'
alias format='find src/ -name "*.js" -exec prettier --write --no-semi --single-quote {} \;'
alias untar='extract'

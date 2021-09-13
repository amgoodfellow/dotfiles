# System Variables -------------------------------------
HISTFILE=~/.histfile
HISTSIZE=8000
SAVEHIST=10000
setopt autocd extendedglob nomatch notify
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/amgoodfellow/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall


# Source from $HOME/.profile
source $HOME/.profile

# Antigen
source /usr/share/zsh/share/antigen.zsh

# Load the oh-my-zsh's library
antigen use oh-my-zsh
# Self-explanatory
antigen bundle git
# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting
# Fish-like auto suggestions
antigen bundle zsh-users/zsh-autosuggestions
# Extra zsh completions
antigen bundlezsh-users/zsh-completions
#substring search
antigen bundle zsh-users/zsh-history-substring-search

antigen theme kphoen
# Tell antigen that you're done
antigen apply


# Autorun exa on every cd
cd() {
  builtin cd "$@";
  exa;
}

# I can never remember the commands for different compressed files
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
alias vim=nvim
alias ls='exa'
alias ll='exa --long'
alias ll='exa --long --all'
alias format='find src/ -name "*.js" -exec prettier --write --no-semi --single-quote {} \;'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

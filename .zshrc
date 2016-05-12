# colors
cyan=%{$fg[cyan]%}
red=%{$fg[red]%}
green=%{$fg[green]%}
blue=%{$fg[blue]%}

export M2_HOME=/home/aaron/uportal/maven
export M2=$M2_HOME/bin
export PATH=$M2:$PATH

export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/
export PATH=$JAVA_HOME/bin:$PATH
export ANT_HOME=/home/aaron/uportal/ant
export PATH=$PATH:$ANT_HOME/bin

export TOMCAT_HOME=/home/aaron/uportal/tomcat
export PATH=$PATH:$TOMCAT_HOME
export JAVA_OPTS="-server -XX:MaxPermSize=512m -Xms1024m -Xmx2048m"

export HSQLDB_HOME='/home/$USER/uportal/hsqldb'
export PATH=$PATH:$HSQLDB_HOME/bin

export ANDROID_HOME=/home/aaron/Android/sdk/
export PATH=$PATH:$ANDROID_HOME

## Arrow Keys ###########################################

# OPTION 1: for most systems
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

source ~/extras/zsh-git-prompt/zshrc.sh

precmd() {

  PROMPT="${green}%n${red}%~ %{$reset_color%}$(git_super_status    )
${blue}> "

}


# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/aaron/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
#Does an 'ls' command every time one changes the directory
cd() {
	builtin cd "$@";
	ls;
}

function tommy {
  for i in "$@"; do
	  if [[ $i == "start" ]]; then
		  $TOMCAT_HOME/bin/startup.sh
	  elif [[ $i == "stop" ]]; then
		  $TOMCAT_HOME/bin/shutdown.sh
	  elif [[ $i == "clean" ]]; then
		  rm -rf $TOMCAT_HOME/webapps/*
			rm -rf $TOMCAT_HOME/work/*
			rm -rf $TOMCAT_HOME/temp/*
    elif [[ $i == "status" ]]; then
		  ps aux | grep -v 'grep' | grep 'tomcat'
		else
      echo "please type start, stop, clean, or status"
    fi
  done
}


alias lll='ls -lart'
alias webapp=~/uportal/uportal/bin/webapp_cntl.sh
source /home/aaron/extras/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /home/aaron/extras/zsh-history-substring-search/zsh-history-substring-search.zsh

# colors
cyan=%{$fg[cyan]%}
red=%{$fg[red]%}
green=%{$fg[green]%}
blue=%{$fg[blue]%}

export M2_HOME=/home/aaron/uportal/maven
export M2=$M2_HOME/bin
export PATH=$M2:$PATH

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
export PATH=$JAVA_HOME/bin:$PATH
export ANT_HOME=/home/aaron/uportal/ant
export PATH=$PATH:$ANT_HOME/bin

export TOMCAT_HOME=/home/aaron/uportal/tomcat
export PATH=$PATH:$TOMCAT_HOME
export JAVA_OPTS="-server -XX:MaxPermSize=512m -Xms512m -Xmx1024m"

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

  PROMPT="${green}%n${red}%~ %{$reset_color%}$(git_super_status)
${blue}> "

}




# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob
bindkey -v
setopt complete_aliases
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

function cleanm2 {
	mkdir .md-copy/
	mv ~/.m2/settings-security.xml ~/.m2-copy/settings-security.xml
	mv ~/.m2/settings.xml ~/.m2-copy/settings.xml

	rm -rf ~/.m2/repository
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
		elif [[ $i == "areyoudie" ]]; then
		  ps aux | grep -v 'grep' | grep 'tomcat'
		elif [[ $i == "logs" ]]; then
			cd ~/uportal/tomcat/logs
		else
      echo "please type start, stop, clean, or status"
    fi
  done
}

fpath=(/home/aaron/.zsh/completion $fpath)

autoload -U compinit
compinit
zstyle ':completion:*' menu select=2
alias webapp=~/uportal/uportal/bin/webapp_cntl.sh

alias lll='ls -lart'
alias ls='ls --color=auto'
compdef _webappCompletion webapp
alias deploy='source deployApp.sh'
alias lock='i3lock -i /home/aaron/Pictures/"windoge.png" -p default -n'
alias zshrc='source ~/.zshrc'

source /home/aaron/extras/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /home/aaron/extras/zsh-history-substring-search/zsh-history-substring-search.zsh

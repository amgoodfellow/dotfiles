# colors
cyan=%{$fg[cyan]%}
red=%{$fg[red]%}
green=%{$fg[green]%}
blue=%{$fg[blue]%}

#export M2_HOME=/home/aaron/uportal/maven
#export M2=$M2_HOME/bin
#export PATH=$M2:$PATH
#
#export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
#export PATH=$JAVA_HOME/bin:$PATH
#export ANT_HOME=/home/aaron/uportal/ant
#export PATH=$PATH:$ANT_HOME/bin
#
#export TOMCAT_HOME=/home/aaron/uportal/tomcat
#export PATH=$PATH:$TOMCAT_HOME
#export JAVA_OPTS="-server -XX:MaxPermSize=512m -Xms512m -Xmx1024m"
#
#export HSQLDB_HOME='/home/$USER/uportal/hsqldb'
#export PATH=$PATH:$HSQLDB_HOME/bin
#
#export ANDROID_HOME=/home/aaron/Android/sdk/
#export PATH=$PATH:$ANDROID_HOME
#
#export GOPATH=/home/aaron/goWork/
#export GOBIN=${GOPATH}/bin
#export PATH=$PATH:$GOBIN
#export GRADLE=/home/aaron/.sdkman/candidates/gradle/current/bin
#export PATH=$PATH:$GRADLE

#Arrow Keys ###########################################


source /home/aaron/extras/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /home/aaron/extras/zsh-history-substring-search/zsh-history-substring-search.zsh

# OPTION 1: for most systems
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

source ~/extras/zsh-git-prompt/zshrc.sh

precmd() {

  PROMPT="${green}%n${red}%~ %{$reset_color%}$(git_super_status)
${blue}>⟹  "

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

#function cleanm2 {
#	mkdir .md-copy/
#	mv ~/.m2/settings-security.xml ~/.m2-copy/settings-security.xml
#	mv ~/.m2/settings.xml ~/.m2-copy/settings.xml
#
#	rm -rf ~/.m2/repository
#}



#function tommy {
#  for i in "$@"; do
#	  if [[ $i == "start" ]]; then
#		  $TOMCAT_HOME/bin/startup.sh
#      tail -f $TOMCAT_HOME/logs/catalina.out
#	  elif [[ $i == "stop" ]]; then
#		  $TOMCAT_HOME/bin/shutdown.sh
#	  elif [[ $i == "clean" ]]; then
#		  rm -rf $TOMCAT_HOME/webapps/*
#			rm -rf $TOMCAT_HOME/work/*
#			rm -rf $TOMCAT_HOME/temp/*
#    elif [[ $i == "webapps" ]]; then
#      cd $TOMCAT_HOME/webapps
#    elif [[ $i == "status" ]]; then
#		  ps aux | grep -v 'grep' | grep 'tomcat'
#		elif [[ $i == "areyoudie" ]]; then
#		  ps aux | grep -v 'grep' | grep 'tomcat'
#		elif [[ $i == "logs" ]]; then
#			cd ~/uportal/tomcat/logs
#		else
#      echo "please type start, stop, clean, or status"
#    fi
#  done
#}


#function quickDeploy {
#  	#find src/main/react/src -name "*.js" -exec prettier --write --no-semi {} \; && \
#	mvn clean package -Dfilters.file=/home/$USER/uportal/uportal/filters/local.properties && \
#	WARPATH=`readlink -f $(find . -name '*.war' -type f)` && \
#	cd ~/uportal/uportal && \
#	ant deployPortletApp -DportletApp=$WARPATH && \
#	cd -	
#}


alias lll='ls -larth'
alias ls='ls --color=auto'
alias zshrc='source ~/.zshrc'
alias clone='git clone'
#alias android='/usr/local/android-studio/bin/studio.sh &'
alias wow='tree'
alias clang-format='clang-format-4.0'
#alias webapp='~/uportal/uportal/bin/webapp_cntl.sh'
alias format='find src/ -name "*.js" -exec prettier --write --no-semi {} \;' 
alias nodejs='node'
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
#export SDKMAN_DIR="/home/aaron/.sdkman"
#[[ -s "/home/aaron/.sdkman/bin/sdkman-init.sh" ]] && source "/home/aaron/.sdkman/bin/sdkman-init.sh"

#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

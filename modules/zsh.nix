{ config, lib, pkgs, ... }: {
  programs.zsh = {
    antidote = {
      enable = true;
      plugins = [ "sindresorhus/pure" ];
    };
    enable = true;
    autosuggestion.enable = true;
    history.extended = true;
    history.findNoDups = true;
    historySubstringSearch.enable = true;
    initContent = ''
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
    '';
    profileExtra = "";
    shellAliases = {
      cd = ''
        builtin cd "$@";
        eza;
      '';
      ls = "eza";
      ll = "eza --long --all";
      pformat = ''
        find src/ -name "*.js" -exec prettier --write --no-semi --single-quote {} ;'';
      hm-update = "home-manager --flake .#desktop";
    };
    syntaxHighlighting.enable = true;
  };
}

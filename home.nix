{ pkgs, ... }: {
  programs.home-manager.enable = true;
  home.stateVersion = "23.05";
  home.username = "amgoodfellow";
  home.homeDirectory = "/home/amgoodfellow";

  home.packages = with pkgs; [
    delta
    fd
    hasklig
    neofetch
    nixfmt
    tree
    unzip
    zip
  ];

  programs.eza.enable = true;
  programs.bat.enable = true;

  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.pandoc.enable = true;
  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;
  programs.jq.enable = true;
  programs.nushell.enable = true;
  programs.ripgrep.enable = true;

  programs.tealdeer = {
    enable = true;
    settings.updates.auto_update = true;
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    prefix = "C-a";
    sensibleOnTop = true;
    extraConfig = ''
      bind - split-window -v
      bind | split-window -h
    '';
  };

  programs.yt-dlp.enable = true;
}

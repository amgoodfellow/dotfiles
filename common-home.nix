{
  lib,
  pkgs,
  username,
  platform,
  stylix,
  ...
}:
let
  homedir = (if platform == "MacOS" then "/Users/" else "/home/") + username;
in
{

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  programs.home-manager.enable = true;
  home.username = username;
  home.homeDirectory = homedir;

  home.packages = with pkgs; [
    alacritty
    clang
    cmake
    delta
    fd
    fira-code
    gimp
    inkscape
    neofetch
    nixfmt-rfc-style
    python313Packages.weasyprint
    spotify
    sqlite
    texliveTeTeX
    tree
    unzip
    zip
  ];

  nixpkgs.config.allowUnfree = true;

  fonts.fontconfig.enable = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
    doom = {
      enable = true;
      executable = false;
      recursive = true;
      source = ./modules/doom;
      target = homedir + "/.doom.d";
    };

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    EDITOR = "emacs";
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs;
    extraPackages = epkgs: [
      epkgs.all-the-icons-nerd-fonts
      epkgs.graphviz-dot-mode
      epkgs.treesit-grammars.with-all-grammars
      epkgs.vterm
    ];
  };

  # Let Home Manager install and manage itself.

  # Other programs that have home-manager integration:

  # The BLAZINGLY FAST version of '(ls cat grep)
  programs.eza.enable = true;
  programs.bat.enable = true;
  programs.ripgrep.enable = true;

  # Like man but quick
  programs.tealdeer = {
    enable = true;
    settings.updates.auto_update = true;
  };

  # So you don't forget to 'nvm use 6' on your legacy codebase
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

  home.stateVersion = "23.11";
}

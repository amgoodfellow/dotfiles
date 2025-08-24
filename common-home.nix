{
  pkgs,
  username,
  platform,
  stylix,
  ...
}:
{

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  programs.home-manager.enable = true;
  home.username = username;
  home.homeDirectory = (if platform == "MacOS" then "/Users/" else "/home/") + username;

  home.packages = with pkgs; [
    borgbackup
    clang
    cmake
    delta
    fd
    fira-code
    neofetch
    nixfmt-rfc-style
    python313Packages.weasyprint
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

  stylix.image = /home/amgoodfellow/Pictures/wallpaper.jpeg;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
  stylix.fonts = {
    serif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Serif";
    };

    sansSerif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Sans";
    };

    monospace = {
      package = pkgs.fira-code;
      name = "FiraCode";
    };

    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };
  };
  home.stateVersion = "23.11";
}

{
  pkgs,
  username,
  platform,
  ...
}:
let
  homedir = (if platform == "MacOS" then "/Users/" else "/home/") + username;
in
{
  programs.home-manager.enable = true;
  home.username = username;
  home.homeDirectory = homedir;

  home.packages = with pkgs; [
    # Utilities
    bat
    eza
    neofetch
    nixfmt
    texliveTeTeX
    tree
    unzip
    zip
    # Applications
    alacritty
    gimp
    inkscape
    spotify

    # Doom Emacs Dependencies
    emacs
    fd
    fira-code
    git
    gnutls
    sqlite
    ripgrep
    # Sometimes you need clang for setting up treesitter grammars
    # clang
  ];

  nixpkgs.config.allowUnfree = true;
  fonts.fontconfig.enable = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # Building this configuration will create a copy of 'dotfiles/doom' in
    # the Nix store. Activating the configuration will then make '~/.config/doom'
    # symlink to the Nix store copy.
    doom = {
      enable = true;
      executable = false;
      recursive = true;
      source = ./modules/doom;
      target = homedir + "/.config/doom";
    };
  };

  home.sessionVariables = {
    EDITOR = "emacs";
  };

  programs.tealdeer = {
    enable = true;
    settings.updates.auto_update = true;
  };

  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.pandoc.enable = true;
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
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

  programs.delta = {
    enable = true;
    options = {
      syntax-theme = "gruvbox-dark";
      side-by-side = true;
    };
  };

  programs.yt-dlp.enable = true;
  home.stateVersion = "23.11";
}

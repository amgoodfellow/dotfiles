{ config, lib, pkgs, ... }: {
  programs.neovim = {
    enable = true;

    extraConfig = lib.fileContents ./init.vim;

    plugins = with pkgs.vimPlugins; [
      # UI
      lightline-vim
      tmuxline-vim
      gruvbox

      # Tools
      nerdtree

      # Languages
      vim-nix
      vim-markdown
      vim-javascript
      typescript-vim
      rust-vim
    ];
  };
}

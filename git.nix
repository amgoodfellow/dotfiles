{ config, pkgs, lib, libs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Aaron Goodfellow";
    userEmail = "amgoodfellow@protonmail.com";

    delta = {
      enable = true;
      options = {
        syntax-theme = "gruvbox-dark";
        side-by-side = true;
      };
    };

    extraConfig = {
      pull.rebase = true;
      init.defaultBranch = "main";
      github.user = "amgoodfellow";

      push.autoSetupRemote = true;

      core.editor = "nvim";
      core.fileMode = false;
      core.ignorecase = false;
    };
  };
}

{ pkgs, ... }: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  programs.home-manager.enable = true;
  home.username = "amgoodfellow";
  home.homeDirectory = "/home/amgoodfellow";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11";
}

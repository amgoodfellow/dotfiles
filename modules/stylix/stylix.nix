{ config, lib, pkgs, platform, username, ... }:
{
  stylix.image = builtins.toFile (if platform == "MacOS" then "/Users/" else "/home/") + username + "/Pictures/wallpaper.jpeg";
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
}

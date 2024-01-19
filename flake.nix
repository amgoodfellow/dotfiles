# Inspiration: https://github.com/Misterio77/nix-starter-configs/blob/main/README.md
# https://github.com/donovanglover/nix-config
{
  description = "New and improved home-manager config";
  inputs = {
    # You can access packages from different nixpkgs revs:
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    stylix,
    ...
  } @ inputs: let
    inherit (self) outputs;
    # Supported systems for your flake packages, shell, etc.
    systems = [
      #"aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
    ];
  in {
    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#desktop'
    homeConfigurations = {
      "desktop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [ ./linux-home.nix ./common-home.nix ./neovim.nix ./git.nix ./zsh.nix ];
      };
      "laptop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [ ./linux-home.nix ./common-home.nix ./neovim.nix ./git.nix ./zsh.nix ];
      };
      "work" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs; isMacOS = true;};
        modules = [ ./macos-home.nix ./common-home.nix ./neovim.nix ./git.nix ./zsh.nix stylix.homeManagerModules.stylix];
      };
    };
  };
}

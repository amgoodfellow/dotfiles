# Inspiration: https://github.com/Misterio77/nix-starter-configs/blob/main/README.md
# https://github.com/donovanglover/nix-config
{
  description = "New and improved home-manager config";

  inputs = {
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

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
      "x86_64-linux"
      "aarch64-darwin"
    ];
  in {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./configuration.nix ];
      };
    };
    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#desktop'
    homeConfigurations = {
      desktop = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs; isWork = false; isMacOS = false; };
        modules = [ ./common-home.nix ./neovim.nix ./git.nix ./zsh.nix stylix.homeManagerModules.stylix];
      };
      #laptop = home-manager.lib.homeManagerConfiguration {
      #  pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
      #  extraSpecialArgs = {inherit inputs outputs; isMacOS = false;};
      #  modules = [ ./linux-home.nix ./common-home.nix ./neovim.nix ./git.nix ./zsh.nix stylix.homeManagerModules.stylix];
      #};
      #work = home-manager.lib.homeManagerConfiguration {
      #  pkgs = nixpkgs.legacyPackages.aarch64-darwin; # Home-manager requires 'pkgs' instance
      #  extraSpecialArgs = {inherit inputs outputs; isMacOS = true;};
      #  modules = [ ./macos-home.nix ./common-home.nix ./neovim.nix ./git.nix ./zsh.nix stylix.homeManagerModules.stylix];
      #};
    };
  };
}

{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  security.polkit.enable = true;

  users.users."amgoodfellow" = {
    isNormalUser = true;
    description = "";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [ ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAamqV7HKSf4DqwP1WpyQJQm5hL0zYeOHELUdyZUoZmg"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINb/AQAIo486O+aFp+sGvhLmTG/lPjAPUX073gxcl2P2"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    neovim
    ripgrep
    git
  ];

  # ---    Syncthing   ------------------------------------------
  services.syncthing = {
    enable = true;
    user = "syncthing";
    group = "syncthing";
    dataDir = "/main-pool/syncthing"; # Use the ZFS dataset for data
    configDir = "/main-pool/syncthing"; # Keep config with the data
    settings = {
      devices = {
        # "" = {
        #   id = "";
        #   autoAcceptFolders = true;
        #   # NOTE:
        #   #   The following should be added manually to each shared folder
        #   #
        #   #     <param key="cleanoutDays" val="20"></param>
        #   #     <param key="keep" val="20"></param>
        #   #
        #   #   Which ought to keep the last 20 versions of the file, or the last 20 days,
        #   #   whichever comes first
        # };
      };
    };
  };
  # -------------------------------------------------------------


  # --- Immich Service ------------------------------------------
  services.immich = {
    enable = true;
    # Point Immich to its dedicated ZFS dataset for uploads
    uploadPath = "/main-pool/immich/upload";
    # Point Immich to its library dataset
    libraryPath = "/main-pool/immich/library";
    # Tell Immich to use the PostgreSQL socket
    database.socket = "/run/postgresql";
    # Use Redis for caching
    redis.socket = "/run/redis/redis.sock";
  };

  # Immich requires a database (PostgreSQL) and a cache (Redis)
  services.redis.enable = true;
  services.postgresql = {
    enable = true;
    # Use the dedicated ZFS dataset for the database
    dataDir = "/main-pool/immich/database";
    # Ensure the immich user can connect
    authentication = ''
      local all all ident
    '';
    ensureUsers = [
      {
        name = "immich";
        ensureDB = true;
      }
    ];
  };
  # --- ---------------------------------------------------------


  # --- Networking ----------------------------------------------
  networking.hostName = "onsite01";
  services.nfs.server.enable = true;
  networking.wireless.enable = false;
  networking.firewall.allowedTCPPorts = [
    # ssh
    22
    8080
    22000
  ];
  networking.firewall.allowedUDPPorts = [
    21027
  ];

  # Make sure the mount points have the correct ownershi
  # systemd.tmpfiles.rules = [
  #   "d /mnt/syncthing 0755 youruser users -"
  #   "d /mnt/immich 0755 immich immich -"
  #   "d /mnt/immich/library 0755 immich immich -"
  #   "d /mnt/immich/database 0700 postgres postgres -"
  #   "d /mnt/immich/thumbs 0755 immich immich -"
  #   "d /mnt/immich/upload 0755 immich immich -"
  # ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}

{
  config,
  lib,
  pkgs,
  pool-name,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  security.polkit.enable = true;

  users.users = {
    "amgoodfellow" = {
      isNormalUser = true;
      description = "";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      packages = with pkgs; [
        neovim
        ripgrep
        git
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAamqV7HKSf4DqwP1WpyQJQm5hL0zYeOHELUdyZUoZmg"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINb/AQAIo486O+aFp+sGvhLmTG/lPjAPUX073gxcl2P2"
      ];
    };
    # Immich and postgres create users automatically
    # Syncthing does not, so we create a user for it
    "syncthing" = {
      isSystemUser = true;
      group = "syncthing";
    };
  };

  nixpkgs.config.allowUnfree = true;

  # ---    Syncthing   ------------------------------------------
  services.syncthing = {
    enable = true;
    user = "syncthing";
    group = "syncthing";
    dataDir = "/${pool-name}/syncthing"; # Use the ZFS dataset for data
    configDir = "/${pool-name}/syncthing"; # Keep config with the data
    # settings = {
    #   devices = {
    #     # "" = {
    #     #   id = "";
    #     #   autoAcceptFolders = true;
    #     #   # NOTE:
    #     #   #   The following should be added manually to each shared folder
    #     #   #
    #     #   #     <param key="cleanoutDays" val="20"></param>
    #     #   #     <param key="keep" val="20"></param>
    #     #   #
    #     #   #   Which ought to keep the last 20 versions of the file, or the last 20 days,
    #     #   #   whichever comes first
    #     # };
    #   };
    # };
  };
  # -------------------------------------------------------------

  # ---  k3S  ----------------------------------------------------
  services.k3s = {
    enable = true;
    role = "server"; # Runs both server and agent on this node
    storageDir = "/mnt/k3s"; # Use the dedicated ZFS dataset
  };
  # -------------------------------------------------------------

  # --- Immich Service ------------------------------------------
  services.immich = {
    enable = true;
    # Point Immich to its dedicated ZFS dataset for uploads
    uploadPath = "/${pool-name}/immich/upload";
    # Point Immich to its library dataset
    libraryPath = "/${pool-name}/immich/library";
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
    dataDir = "/var/lib/postgresql";
    # Ensure the immich user can connect
    authentication = ''
      local all all ident
    '';
    # Add extra dbs / users here when new logical dbs are needed
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
    6443
    10250
  ];
  networking.firewall.allowedUDPPorts = [
    21027
    8472
  ];

  # Make sure the mount points have the correct ownership
  systemd.tmpfiles.rules = [
    "d /mnt/syncthing 0755 syncthing syncthing -"
    "d /mnt/immich 0755 immich immich -"
    "d /mnt/immich/library 0755 immich immich -"
    "d /var/lib/postgresql 0700 postgres postgres -"
    "d /mnt/immich/thumbs 0755 immich immich -"
    "d /mnt/immich/upload 0755 immich immich -"
    "d /mnt/k3s 0755 root root -"
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}

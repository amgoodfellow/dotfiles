{
  config,
  pkgs,
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
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAamqV7HKSf4DqwP1WpyQJQm5hL0zYeOHELUdyZUoZmg" # laptop
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINb/AQAIo486O+aFp+sGvhLmTG/lPjAPUX073gxcl2P2" # desktop
      ];
    };
    "syncthing" = {
      isSystemUser = true;
      group = "syncthing";
    };
    "immich" = {
      isSystemUser = true;
      group = "immich";
    };
  };

  services.borgbackup.repos = {
    desktop = {
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE7TJCsuYZA5UZ9YEEnQM8LWGhyFLqDXXHlWdcKq9QHK amgoodfellow@amgoodfellow-desktop"
      ];
      path = "/main-pool/borg/desktop";
    };
  };

  nixpkgs.config.allowUnfree = true;

  # Used for NFS
  services.rpcbind.enable = true;

  # ---    Syncthing   ------------------------------------------
  services.syncthing = {
    enable = true;
    user = "syncthing";
    group = "syncthing";
    dataDir = "/main-pool/syncthing";
    configDir = "/main-pool/syncthing";
  };
  # -------------------------------------------------------------

  # ---  k3S  ----------------------------------------------------
  services.k3s = {
    enable = true;
    role = "server";
    token = builtins.readFile ./k3s-token;
    clusterInit = true;
    # Uses the main-pool/containerd zfs pool
    extraFlags = [
      "--snapshotter=zfs"
    ];
  };
  # -------------------------------------------------------------

  # --- Immich Service ------------------------------------------
  services.immich = {
    enable = true;
    mediaLocation = "/main-pool/immich";
    host = "0.0.0.0";
    port = 2283;
    database = {
      enable = true;
      user = "immich";
      port = 5432;
      name = "immich";
      createDB = true;
    };
    environment = {
      IMMICH_IGNORE_MOUNT_CHECK_ERRORS = "true";
    };
    redis.enable = true;
    openFirewall = true;
    settings = {
      newVersionCheck.enabled = false;
    };
  };

  services.prometheus.exporters.node = {
    enable = true;
    port = 9000;
    enabledCollectors = [
      "systemd"
      "perf"
    ];
    extraFlags = [
      "--collector.ethtool"
      "--collector.softirqs"
      "--collector.tcpstat"
      "--collector.wifi"
    ];
  };

  services.prometheus = {
    enable = true;
    globalConfig.scrape_interval = "30s"; # "1m"
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [
          {
            targets = [ "localhost:${toString config.services.prometheus.exporters.node.port}" ];
          }
        ];
      }
    ];
  };

  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "0.0.0.0";
        http_port = 3000;
        enable_gzip = true;
      };
      # Prevents Grafana from phoning home
      analytics.reporting_enabled = false;
    };
  };

  # Immich requires a database and a cache
  services.postgresql = {
    enable = true;
    # Use the dedicated ZFS dataset for the database
    dataDir = "/var/lib/postgresql";
    authentication = ''
      local all all ident
    '';
    # Add extra dbs / users here when new logical dbs are needed
    ensureUsers = [
      {
        name = "immich";
        ensureDBOwnership = true;
      }
    ];
    ensureDatabases = [
      "immich"
    ];
  };

  # --- Networking ----------------------------------------------
  networking.hostName = "onsite01";
  services.nfs.server.enable = true;
  networking.firewall.logRefusedPackets = true;
  #networking.wireless.enable = false;
  networking.firewall.allowedTCPPorts = [
    # ssh
    22
    3000
    8080
    9000
    8384
    2283
    22000
    2379 # k3s, etcd clients
    2380 # k3s, etcd peers
    6443 # k3s
    10250
  ];
  networking.firewall.allowedUDPPorts = [
    21027
    22000
    21027
    8472 # k3s, flannel
  ];

  # Make sure the mount points have the correct ownership
  systemd.tmpfiles.rules = [
    "d /main-pool/syncthing 0755 syncthing syncthing -"
    "d /main-pool/immich 0755 immich immich -"
    "d /main-pool/immich/library 0755 immich immich -"
    "d /var/lib/postgresql 0700 postgres postgres -"
    "d /main-pool/immich/thumbs 0755 immich immich -"
    "d /main-pool/immich/upload 0755 immich immich -"
    "d /main-pool/borg/ 0755 borg borg -"
    "d /main-pool/k3s 0755 root root -"
  ];
}

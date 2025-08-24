{ config, lib, pkgs, ... }:

{

  # From the wiki:
  # The 32-bit host ID of the machine, formatted as 8 hexadecimal characters.
  # The primary use case is to ensure when using ZFS that a pool isn’t imported accidentally on a wrong machine.
  # head -c 8 /etc/machine-id
  networking.hostId = "51172aa5";

  # ZFS
  boot.supportedFilesystems = [ "zfs" ];

  services.zfs.autoScrub = {
    enable = true;
    interval = "*-*-1,15 02:30";
  };

  # Ensure parent datasets exist if they aren't mounted themselves
  system.activationScripts.zfs-parents = ''
    ${pkgs.zfs}/bin/zfs create -p main-pool/syncthing
    ${pkgs.zfs}/bin/zfs create -p main-pool/immich
  '';

  boot.zfs = {
    forceImportRoot = false;
    extraPools = [ "main-pool" ];

    poolProperties = {
      "main-pool" = {
        "autotrim" = "on";
        "compression" = "lz4";
        "comment" = "Managed by NixOS";
      };
    };
  };

  # Declaratively define ZFS datasets and their properties
  fileSystems = {
    # -- Syncthing --
    "/main-pool/syncthing" = {
      device = "/main-pool/syncthing";
      fsType = "zfs";
      options = [
        "atime=off"
        "compression=lz4"
      ];
    };

    # -- Immich --

    # The library, for large media files
    "/main-pool/immich/library" = {
      device = "tank/immich/library";
      fsType = "zfs";
      options = [
        # large record size reduces metadata overhead and increases sequential read/write throughput
        "recordsize=1M"
        "atime=off"
        "compression=lz4"
      ];
    };

    # The database
    "/main-pool/immich/database" = {
      device = "tank/immich/database";
      fsType = "zfs";
      options = [
        "recordsize=16k"
        # database writes are preferentially sent to Optane SLOG
        "logbias=latency"
        "atime=off"
      ];
    };

    # The thumbnails
    "/main-pool/immich/thumbs" = {
      device = "tank/immich/thumbs";
      fsType = "zfs";
      options = [
        "recordsize=16k"
        "atime=off"
      ];
    };

    # -- BORG --
    "/main-pool/borg" = {
      device = "/main-pool/borg";
      fsType = "zfs";
      options = [
        "compression=off"
        "recordsize=1M"
        "atime=off"
      ];
    };
  };
}

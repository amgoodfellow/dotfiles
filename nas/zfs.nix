{
  config,
  lib,
  pkgs,
  pool-name,
  ...
}:

{
  # From the wiki:
  # The 32-bit host ID of the machine, formatted as 8 hexadecimal characters.
  # The primary use case is to ensure when using ZFS that a pool isn’t imported accidentally on a wrong machine.
  networking.hostId = builtins.readFile ./newtorking-id;

  # ZFS
  boot.supportedFilesystems = [ "zfs" ];

  services.zfs.autoScrub = {
    enable = true;
    interval = "*-*-1,15 02:30";
  };

  # Ensure parent datasets exist if they aren't mounted themselves
  system.activationScripts.zfs-parents = ''
    ${pkgs.zfs}/bin/zfs create -p ${pool-name}/syncthing
    ${pkgs.zfs}/bin/zfs create -p ${pool-name}/immich
    ${pkgs.zfs}/bin/zfs create -p ${pool-name}/k3s
  '';

  boot.zfs = {
    forceImportRoot = false;
    extraPools = [ "${pool-name}" ];

    poolProperties = {
      "${pool-name}" = {
        "autotrim" = "on";
        "compression" = "lz4";
        "comment" = "Managed by NixOS";
      };
    };
  };

  # Declaratively define ZFS datasets and their properties
  fileSystems = {
    # -- Syncthing --
    "/mnt/syncthing" = {
      device = "/${pool-name}/syncthing";
      fsType = "zfs";
      options = [
        "atime=off"
        "compression=lz4"
      ];
    };

    # -- Immich --

    # The library, for large media files
    "/mnt/immich/library" = {
      device = "${pool-name}/immich/library";
      fsType = "zfs";
      options = [
        # large record size reduces metadata overhead and increases sequential read/write throughput
        "recordsize=1M"
        "atime=off"
        "compression=lz4"
      ];
    };
    # The database
    "/var/lib/postgresql" = {
      device = "${pool-name}/postgres";
      fsType = "zfs";
      options = [
        "recordsize=16k"
        # database writes are preferentially sent to Optane SLOG
        "logbias=latency"
        "atime=off"
      ];
    };
    # The thumbnails
    "/mnt/immich/thumbs" = {
      device = "${pool-name}/immich/thumbs";
      fsType = "zfs";
      options = [
        "recordsize=16k"
        "atime=off"
      ];
    };
    # -- BORG --
    "/mnt/borg" = {
      device = "/${pool-name}/borg";
      fsType = "zfs";
      options = [
        "compression=off"
        "recordsize=1M"
        "atime=off"
      ];
    };

    # -- K3S --
    "/mnt/k3s" = {
      device = "${pool-name}/k3s";
      fsType = "zfs";
      options = [ "atime=off" ]; # Inherits compression=lz4 from parent
    };
  };
}

{
  ...
}:

{
  # From the wiki:
  # The 32-bit host ID of the machine, formatted as 8 hexadecimal characters.
  # The primary use case is to ensure when using ZFS that a pool isn’t imported accidentally on a wrong machine.
  networking.hostId = builtins.readFile ./nas/networking-id;

  # ZFS
  boot.supportedFilesystems = [
    "zfs"
    "nfs"
  ];

  services.zfs.autoScrub = {
    enable = true;
    interval = "*-*-1,15 02:30";
  };

  boot.zfs = {
    extraPools = [ "main-pool" ];
  };
}

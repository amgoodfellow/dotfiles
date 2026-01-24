{
  config,
  pkgs,
  ...
}:

{
  networking.hostName = "amgoodfellow-desktop";

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "amdgpu" ];

  boot.kernelParams = [
    "video=DP-0:3840x2160@60"
    "video=DP-2:3840x2160@60"
  ];

  # OBS nonsense
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';
  security.polkit.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";

    inputClassSections = [
      ''
        Identifier "yubikey"
        MatchIsKeyboard "on"
        MatchProduct "Yubikey"
        Option "XkbLayout" "us"
        Option "XkbVariant" "basic"
      ''

      ''
        Identifier "moonlander"
        MatchIsKeyboard "on"
        MatchProduct "Moonlander"
        Option "XkbLayout" "us"
        Option "XkbVariant" "basic"
      ''
    ];
  };

  # Syncthing
  services.syncthing = {
    enable = true;
    user = "amgoodfellow";
    configDir = "/home/amgoodfellow/.config/syncthing"; # Folder for Syncthing's settings and keys
    dataDir = "/home/amgoodfellow/Documents"; # Default folder for new synced folders
  };

  # STEAM
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # The desktop is struggling to wake from sleep for some reason
  systemd = {
    targets = {
      sleep = {
        enable = false;
        unitConfig.DefaultDependencies = "no";
      };
      suspend = {
        enable = false;
        unitConfig.DefaultDependencies = "no";
      };
      hibernate = {
        enable = false;
        unitConfig.DefaultDependencies = "no";
      };
      "hybrid-sleep" = {
        enable = false;
        unitConfig.DefaultDependencies = "no";
      };
    };
  };

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };

  services.power-profiles-daemon.enable = false;

  # enables support for Bluetooth
  hardware.bluetooth.enable = true;
  # powers up the default Bluetooth controller on boot
  hardware.bluetooth.powerOnBoot = true;

  # VM TIME
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # CONTAINER TIME
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.amgoodfellow = {
    isNormalUser = true;
    description = "Aaron Goodfellow";
    extraGroups = [
      "docker"
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      borgbackup
      discord
      firefox
      #TODO Replace when turns isn't broken
      #freecad
      libreoffice-qt
      obs-studio
      parsec-bin
      prismlauncher
      prusa-slicer
      signal-desktop
      wireguard-tools
      protonvpn-gui
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}

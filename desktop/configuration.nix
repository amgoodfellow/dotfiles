{ config, lib, pkgs, ... }:

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
    perf
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';
  security.polkit.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.graphics.extraPackages = with pkgs; [ amdvlk ];

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

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

  # Enable CUPS to print documents
  services.printing.enable = true;

  # Allows printer auto-discovery
  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
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
      alacritty
      dconf
      discord
      firefox
      freecad
      gimp
      inkscape
      insomnia
      libreoffice-qt
      obs-studio
      parsec-bin
      prismlauncher
      prusa-slicer
      python313Packages.weasyprint
      signal-desktop
      spotify
      sqlite
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

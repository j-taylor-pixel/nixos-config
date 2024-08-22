{ config, pkgs, ... }:


{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./home.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #boot.kernelPackages = pkgs.linuxPackages_latest;

  nix.settings.auto-optimise-store = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  networking.hostName = "AsusZenbook"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;
 
  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.wayland = true; # wayland screensharing sucks

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # passwordless sudo 
  security.sudo.extraRules= [{  
    users = [ "josiah" ];
    commands = [{ 
      command = "ALL" ;
      options= [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
      }
    ];}];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.josiah = {
    isNormalUser = true;
    description = "josiah taylor";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # Keep nixos up to date
  system.autoUpgrade.enable = true;

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  programs.direnv.enable = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    pkgs.zoxide pkgs.fzf
    pkgs.discord pkgs.zoom-us pkgs.xwaylandvideobridge
    pkgs.python311 python3Packages.virtualenv
    pkgs.vscode pkgs.distrobox pkgs.git pkgs.github-desktop
    pkgs.google-chrome
    pkgs.prismlauncher-unwrapped pkgs.jdk17 pkgs.alsa-oss # minecraft dependicies. missing java
    pkgs.iotas # note app
    pkgs.calibre # ebook software to read .epub
    pkgs.gnome.gnome-tweaks
    pkgs.realvnc-vnc-viewer
    pkgs.qbittorrent
    pkgs.google-cloud-sdk
    pkgs.beeper
    pkgs.godot_4
  ];

  services.flatpak.enable = true;

  services.earlyoom = {
      enable = true;
      freeSwapThreshold = 2;
      freeMemThreshold = 2;
      extraArgs = [
          "-g" "--avoid '^(wayland|.gnome-shell-wr|Xwayland|Isolated*)$'"
          "--prefer '^(discord|firefox|.firefox-wrapped)$'"
      ];
  };

  
  networking.firewall.allowedTCPPortRanges = [
    # KDE Connect / GS connect
    { from = 1714; to = 1764; }
  ];
  networking.firewall.allowedUDPPortRanges = [
    # KDE Connect / GS connect
    { from = 1714; to = 1764; }
  ];

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ]; # systray icons
  services.tlp = { # power management and battery health settings
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
    };
  };
  services.power-profiles-daemon.enable = false; # required to be false if tlp is enabled

  # Disable some gnome default applications
  environment.gnome.excludePackages = with pkgs.gnome; [
    epiphany    # web browser
    simple-scan # document scanner
    yelp        # help viewer
    geary       # email client
    seahorse    # password manager
    gnome-font-viewer gnome-clocks
    gnome-contacts gnome-weather pkgs.gnome-connections
    gnome-maps gnome-music 
  ];

  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "josiah" ];
  
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # Steam specific required settings
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w" # Required for Github Desktop
  ];

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List services that you want to enable:
  powerManagement.powertop.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

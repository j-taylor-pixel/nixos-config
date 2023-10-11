# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:


{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.auto-optimise-store = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  networking.hostName = "Asus Zenbook"; # Define your hostname.

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

  services.xserver.displayManager.gdm.wayland = false; # wayland screensharing sucks

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
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

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    pkgs.kitty pkgs.kitty-themes
    pkgs.discord pkgs.zoom-us
    pkgs.python311
    pkgs.vscode
    pkgs.git pkgs.github-desktop    
    pkgs.libreoffice-qt pkgs.hunspell pkgs.hunspellDicts.en_US # Required for libreoffice spellchecker
    pkgs.google-chrome pkgs.netflix
    pkgs.lutris-free pkgs.retroarchFull
    pkgs.prismlauncher-unwrapped pkgs.jdk17 pkgs.alsa-oss # minecraft dependicies
    pkgs.gnome.gnome-tweaks
    #gnome extenstions
    gnomeExtensions.appindicator
    gnomeExtensions.caffeine
    gnomeExtensions.app-icons-taskbar
    gnomeExtensions.dash-to-dock
    gnomeExtensions.maximize-to-empty-workspace
    gnomeExtensions.gsconnect
  ];
  
  networking.firewall.allowedTCPPortRanges = [
    # KDE Connect
    { from = 1714; to = 1764; }
  ];
  networking.firewall.allowedUDPPortRanges = [
    # KDE Connect
    { from = 1714; to = 1764; }
  ];

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ]; # systray icons

  # Disable some gnome default applications
  environment.gnome.excludePackages = with pkgs.gnome; [
    epiphany    # web browser
    simple-scan # document scanner    
    yelp        # help viewer
    geary       # email client
    seahorse    # password manager
    #gnome-calculator 
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
    "openssl-1.1.1w"
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

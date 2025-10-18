# These are the common settings among all of your systems/hosts.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).1

{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  hyprland,
  nix-flatpak,
  catppuccin,
  ...
}:

{
  imports = [
    ./mounts.nix
    ./networking.nix
    ./mime.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];


  # Kernel modules
  # Allows OBS Virtual Cam
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModulePackages = [ pkgs.linuxPackages.v4l2loopback ];

  # Teamviewer
  # Remote Tech Support Software Support
  services.teamviewer.enable = true;

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  # Latest kernel breaks nvidia drivers. Leave this commented out.
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  # Theme
  catppuccin.flavor = "mocha";
  catppuccin.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking

  # Network
  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;
  services.resolved.enable = true;
  #networking.networkmanager.connectivity = {
  #  enabled = true;
  #  uri = "https://nm.check.gnome.org/check_network_status.text";
  #  interval = 300;
  #};

  # Locale
  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # X11
  services.xserver.xkb.layout = "de";
  console.keyMap = "de";
  #services.xserver.enable = true; # Enable the X11 windowing system:
  services.xserver.displayManager.gdm.enable = true; # Enable Display Manager (Log-in)

  # Programs
  #programs.steam.enable = true; # Needs to be in system conf for alvr.
  services.ollama.enable = true; # Local LLM
  virtualisation.docker.rootless.enable = true;
  virtualisation.docker.enable = true;

  # Lossless Scaling
  #services.lsfg-vk = {
  #  enable = true;
  #  ui.enable = true; # installs gui for configuring lsfg-vk
  #};

  # Drawing Tablets/MS Surface
  hardware.opentabletdriver.enable = true;
  hardware.opentabletdriver.daemon.enable = true;
  boot.blacklistedKernelModules = [
    "wacom"
    "hid_uclogic"
  ];

  # Hyprland
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
  services.gnome.gnome-keyring.enable = true;
  programs.dconf.enable = true;

  # Fix blurry electron apps
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";

  # Flatpak
  services.flatpak.enable = true;

  # User Set-Up
  users.users.shaydelity = {
    isNormalUser = true;
    description = "Shayde";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # VERY IMPORTANT:
  # sudo tailscale up --operator=$USER
  services.tailscale.enable = true;

  # Set-Up Syncthing
  #services.syncthing = {
  #  enable = true;
  #  openDefaultPorts = true;
  #  user = "shaydelity";
  #  group = "users";
  #  dataDir = "/home/shaydelity";
  #  configDir = "/home/shaydelity/.config/syncthing";
  #};

  # Make unmounted disks appear in dolphin
  services.udisks2.enable = true;

  # Additional packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    v4l-utils # For OBS virtual cam
    webkitgtk_4_1
    micro
    killall
    zstd
    #prismlauncher
    docker
    hyprpolkitagent
    zip
    unzip
    unrar
    kdePackages.ark
    exfatprogs
    networkmanagerapplet
    wpa_supplicant

    # Dolphin Packages
    kdePackages.qtsvg
    kdePackages.kio-fuse
    kdePackages.kio-extras
    kdePackages.ffmpegthumbs
  ];

  # Make Stable Packages available in Home Manager
  home-manager = {
    extraSpecialArgs = {
      inherit pkgs-unstable;
    };
  };

  # Allow dynamically linked executables
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
    icu
  ];

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.droid-sans-mono
    #nerdfonts  # For icons
  ];

  # Fix unpopulated MIME menus in dolphin
  environment.etc."/xdg/menus/applications.menu".text =
    builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser ];
    services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };


  # Enable sound with pipewire.
  # hardware.pulseaudio.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Disable `sudo` Password
  security.sudo.wheelNeedsPassword = false;

  # Optimizes Nix Package Cache
  nix.optimise.automatic = true;

  # Garbage collection
  # Removes old generations and their packages.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 50d";
  };
}

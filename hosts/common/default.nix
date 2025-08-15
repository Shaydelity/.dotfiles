 
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, pkgs-unstable, inputs, ... }:
let
  # Hyprland mesa
  pkgs-hypr = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  # Latest kernel breaks nvidia drivers. Leave this commented out.
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.firewall.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking

  # Network
  networking.networkmanager.enable = true;
  services.resolved.enable = true;

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

  services.xserver.xkb.layout = "de";
  console.keyMap = "de";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Display Manager
  services.xserver.displayManager.gdm.enable = true;

  nixpkgs.config.allowUnfree = true;

  # Programs
  programs.steam.enable = true;  # Needs to be in system conf for alvr.

  # Make unmounted disks appear in dolphin
  services.udisks2.enable = true;

  # Hyprland
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };
  programs.hyprland ={
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
  services.gnome.gnome-keyring.enable = true;
  programs.dconf.enable = true;

  # Fix blurry electron apps
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Services
  services.flatpak.enable = true;

  users.users.shaydelity = {
    isNormalUser = true;
    description = "Shayde";
    extraGroups = [ "networkmanager" "wheel" ];
  };


  # Additional packages (nix search <pkg>)
  environment.systemPackages = with pkgs; [
    micro
    killall
    zstd
    prismlauncher
    docker
    hyprpolkitagent
    zip
    unzip
    unrar
    kdePackages.ark
    exfatprogs
  ];

  home-manager = {
    extraSpecialArgs = {
      inherit pkgs-unstable;
    };
  };

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.droid-sans-mono
    # nerdfonts  # For icons
  ];

  # Fix unpopulated MIME menus in dolphin
  environment.etc."/xdg/menus/applications.menu".text = builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";


  # Enable CUPS to print documents.
  services.printing.enable = true;
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

  # AMD graphics
  hardware.graphics = {
     enable = true;
     package = pkgs-hypr.mesa;
     extraPackages = with pkgs; [
       libva
       libvdpau-va-gl
       vulkan-loader
       vulkan-validation-layers
       amdvlk  # Optional: AMD's proprietary Vulkan driver
       mesa.opencl  # Enables Rusticl (OpenCL) support
       rocmPackages.clr.icd
     ];
   };

  security.sudo.wheelNeedsPassword = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}

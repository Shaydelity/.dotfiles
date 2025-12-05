{
  config,
  pkgs,
  pkgs-stable,
  inputs,
  globals,
  ...
}:

{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg: true;

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useUserPackages = true;
    useGlobalPkgs = true;

    users.${globals.user} = {
      imports = [
        inputs.hyprland.homeManagerModules.default
        inputs.nix-flatpak.homeManagerModules.nix-flatpak
      ];

      home = {
        username = "${globals.user}";
        homeDirectory = "/home/${globals.user}";
      };

      services.flatpak.remotes = [
        {
          name = "flathub";
          location = "https://flathub.org/repo/flathub.flatpakrepo";
        }
      ];

      services.flatpak.update.auto.enable = false;
      services.flatpak.uninstallUnmanaged = false;

      # Make home-manager manage itself
      programs.home-manager.enable = true;
    };
    extraSpecialArgs = {
      inherit pkgs-stable;
    };
  };

  services.flatpak.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Locale options
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

  users.users.${globals.user} = {
    isNormalUser = true;
    description = "${globals.user}";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # Allow dynamically linked executables
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    icu
  ];

  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nix.optimise.automatic = true;
  security.sudo.wheelNeedsPassword = false;
}

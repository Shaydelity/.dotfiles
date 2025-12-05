{
  description = "Shaydelity's NixOS Flake";

  inputs = {
    # Standard Nix Packages
    # Unstable as standard as they are commonly newer.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # VR Packages
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";

    # Home Manager
    # Handles the entire Desktop
    # Default Configs for Hosts override the Home Manager
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Flatpak for home manager
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    # Catppuccin (Unused for now)
    # A color scheme.
    catppuccin.url = "github:catppuccin/nix";

    # Hyprland
    # Tiling based Window Manager & Desktop.
    hyprland.url = "github:hyprwm/Hyprland?submodules=1";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };

    # Framework stuff
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
#     fw-fanctrl = {
#       url = "github:TamtamHero/fw-fanctrl/packaging/nix";
#       inputs.nixpkgs.follows = "nixpkgs";
#     };

    # Lossless scaling
    lsfg-vk-flake.url = "github:pabloaul/lsfg-vk-flake/main";
    lsfg-vk-flake.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

    # Lossless scaling -
    # Steam-App required, needs to be installed in standard directory, start game, need to add profile in LSFG-VK and adjust scaling
    #lsfg-vk-flake.url = "github:pabloaul/lsfg-vk-flake/main";
    #lsfg-vk-flake.inputs.nixpkgs.follows = "nixpkgs";

    # Index Database (Not set up yet)
    # Allows searching for files in all nix packages.
    # Is useful if you have an error with missing dependencies.
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:nix-community/nix-index-database";

    # Surface Linux Compatibility
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs =
    { self, ... }@inputs:
    let
      globals = {
        user = "shaydelity";
        install-dir = "~/.dotfiles"; # No trailing slash!
      };
      flake = self;
    in
    rec {
      formatter.x86_64-linux = inputs.nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;

      nixosConfigurations = {
        shaydelith = import ./hosts/shaydelith { inherit flake inputs globals; };
        eclipse = import ./hosts/eclipse { inherit flake inputs globals; };
        nyx= import ./hosts/nyx { inherit flake inputs globals; };
      };
  };
}

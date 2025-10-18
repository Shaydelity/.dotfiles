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

    # Hyprland Workspaces per Monitor
    #split-monitor-workspaces = {
    #  url = "github:Duckonaut/split-monitor-workspaces";
    #  inputs.hyprland.follows = "hyprland";
    #};
    hypr-dynamic-cursors = {
      url = "github:VirtCode/hypr-dynamic-cursors";
      inputs.hyprland.follows = "hyprland";
    };

    # Framework Hardware (Will be relevant in the future ;3)
    #nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    #fw-fanctrl = {
    #  url = "github:TamtamHero/fw-fanctrl/packaging/nix";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

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
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixpkgs-xr,
      home-manager,
      nix-flatpak,
      catppuccin,
      hyprland,
      #split-monitor-workspaces,
      nixos-hardware,
      #fw-fanctrl,
      #lsfg-vk-flake,
      nix-index-database,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { system = system; };
      pkgs-unstable = import nixpkgs-unstable { system = system; };
    in {
      nixosConfigurations = {
        shaydelith = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit home-manager;
            inherit hyprland;
            inherit nix-flatpak;
            inherit catppuccin;
            inherit pkgs-unstable;
          };
          modules = [
            catppuccin.nixosModules.catppuccin
            nix-index-database.nixosModules.nix-index
            home-manager.nixosModules.home-manager
            #lsfg-vk-flake.nixosModules.default
            ./hosts/shaydelith
          ];
        };
        eclipse = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit home-manager;
            inherit pkgs-unstable;
            inherit hyprland;
            inherit nix-flatpak;
            inherit catppuccin;
          };
          modules = [
            catppuccin.nixosModules.catppuccin
            nix-index-database.nixosModules.nix-index
            home-manager.nixosModules.home-manager
            #lsfg-vk-flake.nixosModules.default
            #nixos-hardware.nixosModules.microsoft-surface-common
            ./hosts/eclipse
          ];
        };
      };
    };
}

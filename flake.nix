 
{
  description = "Zohiu's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Flatpak for home manager
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland?submodules=1";
      hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };
    hypr-dynamic-cursors = {
        url = "github:VirtCode/hypr-dynamic-cursors";
        inputs.hyprland.follows = "hyprland";
    };

    # Framework stuff
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    fw-fanctrl = {
      url = "github:TamtamHero/fw-fanctrl/packaging/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-flatpak, hyprland, split-monitor-workspaces, nixos-hardware, fw-fanctrl, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        zohiupc = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [
            ./hosts/zohiupc
            home-manager.nixosModules.home-manager

            {
              home-manager.extraSpecialArgs = {inherit inputs;};
              home-manager.useUserPackages = true;
              home-manager.users.samy = {
                imports = [
                  hyprland.homeManagerModules.default
                  nix-flatpak.homeManagerModules.nix-flatpak
                  ./home/home.nix
                ];
              };
            }
          ];
        };

        framework = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [
            nixos-hardware.nixosModules.framework-13-7040-amd
            fw-fanctrl.nixosModules.default
            home-manager.nixosModules.home-manager
            ./hosts/framework

            {
              home-manager.extraSpecialArgs = {inherit inputs;};
              home-manager.useUserPackages = true;
              home-manager.users.samy = {
                imports = [
                  hyprland.homeManagerModules.default
                  nix-flatpak.homeManagerModules.nix-flatpak
                  ./home/home.nix
                ];
              };
            }
          ];
        };
      };
    };
}

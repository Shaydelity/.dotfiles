 
{
  description = "Shaydelity's NixOS Flake";

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
    #split-monitor-workspaces = {
    #  url = "github:Duckonaut/split-monitor-workspaces";
    #  inputs.hyprland.follows = "hyprland";
    #};
    hypr-dynamic-cursors = {
        url = "github:VirtCode/hypr-dynamic-cursors";
        inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-flatpak, hyprland, ... }@inputs: # split-monitor-workspaces
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        shaydelith = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [
            ./hosts/shaydelith
            home-manager.nixosModules.home-manager

            {
              home-manager.extraSpecialArgs = {inherit inputs;};
              home-manager.useUserPackages = true;
              home-manager.users.shaydelity = {
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

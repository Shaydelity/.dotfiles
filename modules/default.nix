{
  config,
  pkgs,
  pkgs-unstable,
  zstd,
  nix-flatpak,
  hyprland,
  inputs,
  ...
}:
{
  imports = [
    # hyprland.homeManagerModules.default
    #./environment
    ./programs
    ./scripts
    ./desktop
  ];

  home = {
    username = "shaydelity";
    homeDirectory = "/home/shaydelity";
  };

}

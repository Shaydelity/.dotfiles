{
  lib,
  globals,
  pkgs,
  ...
}:
let
  #hytale-pkg = pkgs.callPackage ./hytale-launcher.nix { };
in
{
  imports = [
    ./lossless-scaling.nix
    ./gale.nix
  ];

  programs.steam.enable = true;
  programs.corectrl.enable = true;

  home-manager.users.${globals.user} = {
    home.packages = (
      with pkgs;
      [
        osu-lazer
        protonplus
        prismlauncher
        moonlight-qt
        gamescope

        # Emulation
        cemu

        #hytale-pkg
      ]
    );
  };
}

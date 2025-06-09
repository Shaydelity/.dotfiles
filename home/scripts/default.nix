{ config, lib, pkgs, ... }:
let

search = pkgs.writeShellScriptBin "search" ''
nix search nixpkgs $1
'';

cava-internal = pkgs.writeShellScriptBin "cava-internal" ''
  cava -p ~/.config/cava/config1 | sed -u 's/;//g;s/0/▁/g;s/1/▂/g;s/2/▃/g;s/3/▄/g;s/4/▅/g;s/5/▆/g;s/6/▇/g;s/7/█/g;'
'';

wallpaper_random = pkgs.writeShellScriptBin "wallpaper_random" ''
bash -c "swww img $(find ~/.config/home-manager/wallpapers/ -type f | shuf -n 1)"
'';

in
{
  home.packages = with pkgs; [
    search
    cava-internal
    wallpaper_random
  ];
}

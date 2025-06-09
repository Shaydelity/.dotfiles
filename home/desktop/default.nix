{ config, lib, pkgs, ... }:
{
  imports = [
    ./hypr
    ./waybar
    ./mako
    ./rofi
    ./cava
  ];
}

 
{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../common
    ./nvidia.nix
    ./mount.nix
  ];

  networking.hostName = "shaydelith"; # Define your hostname.
}

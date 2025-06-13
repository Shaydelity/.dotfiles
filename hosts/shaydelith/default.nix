 
{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./nvidia.nix
    ./mount.nix
    ../common
  ];

  networking.hostName = "shaydelith"; # Define your hostname.
}

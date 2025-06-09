 
{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../common
    ./nvidia.nix
  ];

  networking.hostName = "shaydelith"; # Define your hostname.
}

 
{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../common
  ];

  networking.hostName = "eclipse"; # Define your hostname.
}

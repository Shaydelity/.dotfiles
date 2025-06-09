 
{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../common
  ];

  networking.hostName = "zohiupc";
}

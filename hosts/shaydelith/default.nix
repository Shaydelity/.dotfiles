 
{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./nvidia.nix
    ./mount.nix
    ../common
  ];

  networking.hostName = "shaydelith"; # Define your hostname.

  environment.systemPackages = with pkgs; [
    micro
    killall
    zstd
    prismlauncher
    docker
  ];

  virtualisation.docker.enable = true;

}

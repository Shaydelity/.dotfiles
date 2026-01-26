{ lib, ... }:
{
  imports = [
    ./bluetooth.nix
    ./connection.nix
    ./mounts.nix
    ./tailscale.nix
  ];
}

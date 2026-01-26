{ lib, ... }:
{
  imports = [
    ./docker.nix
    ./git.nix
    ./godot.nix
    ./vscodium.nix
  ];
}

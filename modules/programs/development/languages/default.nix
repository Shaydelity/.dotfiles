{ lib, ... }:
{
  imports = [
    ./c.nix
    ./python.nix
    ./rust.nix
    ./racket.nix
  ];
}

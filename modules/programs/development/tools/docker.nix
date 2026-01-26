{ pkgs, globals, ... }:
{
  virtualisation.docker = {
    enable = true;
  };

  users.users.${globals.user}.extraGroups = [ "docker" ];
}

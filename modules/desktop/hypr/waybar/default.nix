{
  config,
  lib,
  pkgs,
  globals,
  ...
}:

{
  home-manager.users.${globals.user} = {
    programs.waybar.enable = true;

    xdg.configFile."waybar" = {
      source = ./config;
      recursive = true;
    };
  };
}

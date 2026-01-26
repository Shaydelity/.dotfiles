{
  config,
  lib,
  pkgs,
  globals,
  ...
}:

{
  home-manager.users.${globals.user} = {
    home.packages = with pkgs; [
      libnotify
    ];

    services.mako = {
      enable = true;
    };

    xdg.configFile."mako" = {
      source = ./config;
      recursive = true;
    };
  };
}

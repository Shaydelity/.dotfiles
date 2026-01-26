{ globals, pkgs, ... }:
{
  home-manager.users.${globals.user} = {
    home.packages = (
      with pkgs;
      [
        btop
      ]
    );

    xdg.configFile."btop" = {
      source = ./config;
      recursive = true;
    };
  };
}

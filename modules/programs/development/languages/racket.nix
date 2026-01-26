{
  lib,
  pkgs,
  globals,
  ...
}:
{
  home-manager.users.${globals.user} = {
    home.packages = (
      with pkgs;
      [
        racket
      ]
    );
  };
}

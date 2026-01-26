{
  lib,
  globals,
  pkgs,
  ...
}:
{
  home-manager.users.${globals.user} = {
    home.packages = (
      with pkgs;
      [
        obsidian
        teams-for-linux
        teamviewer
        virt-viewer
        libreoffice-qt6-fresh
      ]
    );
  };
}

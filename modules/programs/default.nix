# This file should not install programs but I currently use it for that.
{
  lib,
  globals,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  imports = [
    ./development
    ./essentials
    ./gaming
    ./media
    ./scripts
    ./workflow
  ];

  home-manager.users.${globals.user} = {
    services.flatpak.packages = [
      "com.bktus.gpgfrontend"
      "com.github.tchx84.Flatseal"
      "org.gnome.SimpleScan"
    ];
    home.packages = (
      with pkgs;
      [
        zoom-us
        # GUI apps
        amberol
        zenity
        yt-dlp

        alvr

        drawio
        pkgs-unstable.r2modman

        nextcloud-client
        tenacity

        android-studio
        wlr-randr
        git
        nitch
        wget
        gnumake

      ]
    );
  };
}

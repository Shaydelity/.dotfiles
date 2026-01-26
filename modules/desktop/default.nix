{
  lib,
  pkgs,
  pkgs-stable,
  inputs,
  globals,
  ...
}:
{
  imports = [
    ./hypr
    ./plymouth
    ./mime.nix
    ./audio.nix
  ];

  # Fix blurry electron apps
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";

  # Additional packages
  environment.systemPackages = with pkgs; [
    kdePackages.qtsvg
    kdePackages.kio-fuse
    kdePackages.kio-extras
    kdePackages.ffmpegthumbs
    webkitgtk_4_1
  ];

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.droid-sans-mono
    # nerdfonts  # For icons
  ];

  # Fix unpopulated MIME menus in dolphin
  # environment.etc."/xdg/menus/applications.menu".text =
  #   builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
}

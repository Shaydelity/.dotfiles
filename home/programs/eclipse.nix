{
  config,
  pkgs,
  pkgs-unstable,
  zstd,
  nix-flatpak,
  hyprland,
  inputs,
  ...
}:
{
  imports = [
    ./btop
    ./fish
    ./git
#     ./gnupg
    ./kitty
    ./micro
    ./mpv
    ./vscodium
    ./gale.nix
  ];


  #services.flatpak.remotes = [{
  #  name = "flathub";
  #  location = "https://flathub.org/repo/flathub.flatpakrepo";
  #}];

  #services.flatpak.update.auto.enable = false;
  #services.flatpak.uninstallUnmanaged = false;

  nixpkgs.config.allowUnfree = true;

  #services.flatpak.packages = [
#     "com.bktus.gpgfrontend"
    #"org.prismlauncher.PrismLauncher"
    #"io.github.MakovWait.Godots"
#     "com.github.tchx84.Flatseal"
    #"com.vscodium.codium"
    #"org.gnome.SimpleScan"
#   ];

  # Also need to rebuild nix to fix dolphin MIME
  home.packages = (with pkgs; [
    # GUI apps
    kitty
    mpv
    blueman
    nemo-with-extensions
    firefox
    vivaldi
    alvr
    krita
    kdePackages.dolphin # dolphin
    kdePackages.kate # kate
    kdePackages.ark # ark
    #gimp
    discord
    obsidian
    drawio
    nextcloud-client
    signal-desktop
    #tenacity
    # steam - Installed in system config for the system access.
    #godot

    gnome-network-displays

    # Command line utils
    fish
    # wine (32)
    # wine64
    # wineWowPackages.waylandFull
    wineWowPackages.stable
    winetricks
    wlr-randr
    git
    nitch
    wget
    rustup
    gnumake
    curl
    appimage-run
    sqlite
    (python312.withPackages (p: with p; [
      build
    ]))

    # TUI apps
    micro
    nano
    btop

  ]);

  programs.home-manager.enable = true;
  home.stateVersion = "25.05";

  #systemd.user.services.nextcloud-client = {
  #  enable = true;
  #  wantedBy = [ "graphical-session.target" ];
  #  after = [ "graphical-session.target" ];
  #  serviceConfig = {
  #    ExecStart = "${pkgs.nextcloud-client}/bin/nextcloud";
  #    Restart = "on-failure";
  #  };
  #};
}

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


  services.flatpak.remotes = [{
    name = "flathub";
    location = "https://flathub.org/repo/flathub.flatpakrepo";
  }];

  services.flatpak.update.auto.enable = false;
  services.flatpak.uninstallUnmanaged = false;

  # The below code does work.
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  # nixpkgs-unstable = {
  #   config = {
  #     allowUnfree = true;
  #     allowUnfreePredicate = (_: true);
  #   };
  # };

  # nixpkgs.config.allowUnfree = true;
  # nixpkgs-unstable.config.allowUnfree = true;
  #pks-unstable.config.allowUnfree = true;

  services.flatpak.packages = [
    "com.bktus.gpgfrontend"
    #"org.prismlauncher.PrismLauncher"
    "io.github.MakovWait.Godots"
    "com.github.tchx84.Flatseal"
    "com.vscodium.codium"
    "org.gnome.SimpleScan"
  ];

  home.packages = ( with pkgs; [
    zoom-us
    # GUI apps
    amberol
    zenity
    yt-dlp
    bitwarden-desktop
    kitty
    mpv
    blueman
    nemo-with-extensions
    firefox
    chromium
    vivaldi
    alvr
    kdePackages.dolphin # dolphin
    kdePackages.kate # kate
    kdePackages.ark # ark
    moonlight-qt
    gimp
    libreoffice-fresh
    discord
    obs-studio
    obsidian
    drawio
    nextcloud-client
    pkgs-unstable.signal-desktop
#     pkgs-unstable.unityhub
    pkgs-unstable.inkscape
    # pks-unstable.osu-lazer-bin
    osu-lazer-bin
    blender
    blockbench
    bitwig-studio
    davinci-resolve
    tenacity
    kdePackages.gwenview
    # steam - Installed in system config for the system access.
    pkgs-unstable.r2modman
    godot

    jellyfin-media-player
    gnome-network-displays

    jetbrains.pycharm-community-bin
    jetbrains.idea-community-bin
    android-studio

    # Command line utils
    fish
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

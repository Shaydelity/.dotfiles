{ pkgs, ... }: {

  imports = [
    # hyprland.homeManagerModules.default
    #./environment
    ./programs
    ./scripts
    ./desktop
  ];

  home = {
    username = "shaydelity";
    homeDirectory = "/home/shaydelity";
  };

  services.flatpak.remotes = [{
    name = "flathub";
    location = "https://flathub.org/repo/flathub.flatpakrepo";
  }];

  services.flatpak.update.auto.enable = false;
  services.flatpak.uninstallUnmanaged = false;

  nixpkgs.config.allowUnfree = true;

  services.flatpak.packages = [
    "com.bktus.gpgfrontend"
    "org.prismlauncher.PrismLauncher"
    "io.github.MakovWait.Godots"
    "com.github.tchx84.Flatseal"
    "com.vscodium.codium"
  ];


  # Also need to rebuild nix to fix dolphin MIME
  home.packages = (with pkgs; [
    # GUI apps
    kitty
    mpv
    blueman
    nemo-with-extensions
    firefox
    chromium
    vivaldi
    alvr
    # dolphin
    libsForQt5.dolphin
    # ark
    libsForQt5.ark
    moonlight-qt
    gimp
    libreoffice-fresh
    discord
    obs-studio
    obsidian
    drawio
    nextcloud-client
    signal-desktop
    blender
    blockbench
    bitwig-studio
    davinci-resolve
    tenacity
    # Don't uncomment! - Steam is installed in system config to allow system access.
    # steam
    r2modman
    godot

    jellyfin-media-player
    gnome-network-displays

    jetbrains.pycharm-community-bin
    jetbrains.idea-community-bin

    # Command line utils
    fish
    wine
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

  programs.git = {
    enable = true;
    userName  = "Shaydelity";
    userEmail = "shaydedg@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.home-manager.enable = true;
  home.stateVersion = "25.05";
}

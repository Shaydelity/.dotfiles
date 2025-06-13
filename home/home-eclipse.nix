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
    "org.gnome.SimpleScan"
  ];

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
    libsForQt5.dolphin # dolphin
    libsForQt5.kate # kate
    libsForQt5.ark # ark
    gimp
    libreoffice-fresh
    discord
    obsidian
    drawio
    nextcloud-client
    signal-desktop
    tenacity
    # steam - Installed in system config for the system access.
    r2modman
    godot

    gnome-network-displays

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

{ pkgs, inputs, ... }: {

  imports = [
    ./programs
    ./scripts
    ./desktop
  ];

  home = {
    username = "samy";
    homeDirectory = "/home/samy";
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
    alvr
    bitwarden-desktop

    libsForQt5.dolphin
    libsForQt5.kio-extras
    libsForQt5.ffmpegthumbs

    libsForQt5.ark
    libsForQt5.kate
    moonlight-qt
    gimp
    libreoffice-fresh
    obs-studio
    obsidian
    signal-desktop
    tidal-hifi
    blender
    blockbench
    bitwig-studio
    davinci-resolve
    sqlitebrowser
    trayscale
    r2modman
    audacity
    qpwgraph

    jellyfin-media-player
    gnome-network-displays
    inkscape

    jetbrains.pycharm-community-bin
    jetbrains.idea-community-bin

    # Command line utils
    fish
    wlr-randr
    nitch
    neofetch
    wget
    rustup
    gnumake
    catimg
    curl
    appimage-run
    sqlite
    (python312.withPackages (p: with p; [
      build
    ]))
    gnupg
    # pinentry

    # TUI apps
    micro
    nano
    btop

    # Libs / Requirements

  ]);

  programs.git = {
    enable = true;
    userName  = "Zohiu";
    userEmail = "mail@zohiu.de";
    extraConfig = {
      credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";
      commit.gpgsign = true;
      user.signingkey = "F93EC485BC2ED258";
      init.defaultBranch = "main";
    };
  };

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
}

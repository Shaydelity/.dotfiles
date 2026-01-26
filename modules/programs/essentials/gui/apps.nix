{
  lib,
  globals,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  home-manager.users.${globals.user} = {
    services.flatpak.packages = [
      "com.github.tchx84.Flatseal"
      "com.bktus.gpgfrontend"
    ];

    home.packages = (
      with pkgs;
      [
        # Browsers
        firefox
        chromium
        ladybird
        vivaldi

        bitwarden-desktop

        # Social
        discord
        pkgs-unstable.signal-desktop

        nemo-with-extensions
        nemo-preview
        nemo-fileroller
        nemo-seahorse
        gvfs

        kdePackages.dolphin # dolphin
        kdePackages.kate # kate
        kdePackages.ark # ark
        kdePackages.gwenview

        jellyfin-media-player
        gnome-network-displays

        wineWowPackages.stable
        winetricks

        file-roller
        mate.pluma

        cosmic-edit
        cosmic-files

        # Admin tools / Other
        qpwgraph
        gparted
      ]
    );

    dconf = {
      settings = {
        "org/cinnamon/desktop/applications/terminal" = {
          exec = "kitty";
        };
      };
    };

    xdg.configFile."gtk-3.0/bookmarks".text = ''
      file:///home/${globals.user}/.dotfiles .dotfiles
      file:///home/${globals.user}/Downloads Downloads
      file:///home/${globals.user}/Development Development
      file:///home/${globals.user}/Documents Documents
      file:///home/${globals.user}/Pictures Pictures
      file:///home/${globals.user}/Videos Videos
      file:///home/${globals.user}/Music Music
    '';

    #programs.thunderbird = {
    #enable = true;
    #profiles = {
    #"x7z6kjks.default" = {
    #isDefault = true;
    #};
    #};
    #};
  };
}

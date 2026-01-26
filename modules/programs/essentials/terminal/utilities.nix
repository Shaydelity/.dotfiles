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
        micro
        nano

        wget
        curl

        # Fun tools
        nitch
        neofetch

        # TUI apps
        libqalculate
        wikiman
        lynx

        # Command line tools
        tldr
        ncdu
        lsd
        fzf
        fd
        bat
        broot
      ]
    );

    # Micro
    xdg.configFile."micro/settings.json".text = ''
      {
        "tabstospaces": true,
        "tabsize": 2,
        "colorscheme": "simple",
      }
    '';

    xdg.configFile."micro/bindings.json".text = ''
      {
        "Ctrl-S": "Save",
        "Ctrl-X": "Quit",
        "Ctrl-Z": "Undo",
        "Ctrl-Y": "Redo",
      }
    '';
  };
}

{
  lib,
  globals,
  pkgs,
  ...
}:
let
  # When updating the version, make sure to use the 'nix-prefetch-url' command
  # to get the sha256 of that version, then update the fetchurl below.
  # For the icon you only need to do it if the icon changes, which will likely be rare.
  version = "1.11.1";

  galeAppImage = pkgs.appimageTools.wrapType2 {
    pname = "gale-appimage";
    inherit version;
    src = pkgs.fetchurl {
      url = "https://github.com/Kesomannen/gale/releases/download/${version}/Gale_${version}_amd64_linux.AppImage";
      sha256 = "059gp5379l61hwkxpcc4jgvg7p4nzdfmf4i75a915lwj9aaxz8l9";
    };
  };

  galeWrapped =
    pkgs.runCommand "gale-appimage"
      {
        nativeBuildInputs = [ pkgs.makeWrapper ];
      }
      ''
        mkdir -p $out/bin
        makeWrapper \
          ${galeAppImage}/bin/gale-appimage \
          $out/bin/gale-appimage \
          --set WEBKIT_DISABLE_DMABUF_RENDERER 1
      '';

  galeIcon = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Kesomannen/gale/refs/heads/master/images/icons/app-icon.png";
    sha256 = "0yvk764lck1zg72g1jvmyqhysi09i5331hxvcwzwhp8dimkslk2x";
  };

  galeDesktopEntry = {
    name = "Gale";
    comment = "A modern mod manager for Thunderstore.";
    exec = "gale-appimage";
    icon = "gale";
    terminal = false;
    categories = [
      "Game"
      "Utility"
    ];
  };
in
{
  home-manager.users.${globals.user} = {
    home.packages = [
      galeWrapped
    ];

    xdg.dataFile."icons/hicolor/256x256/apps/gale.png".source = galeIcon;
    xdg.desktopEntries.gale = galeDesktopEntry;
  };
}

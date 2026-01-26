{
  lib,
  pkgs,
  globals,
  ...
}:
{
  imports = [
    ./obs.nix
  ];

  home-manager.users.${globals.user} = {
    services.flatpak.packages = [
      "org.jdownloader.JDownloader"
      "app.grayjay.Grayjay"
    ];

    home.packages = (
      with pkgs;
      [
        # Basic creation tools
        gimp3

        # Media ripping / conversion
        makemkv
        handbrake
        ffmpeg-full
        n-m3u8dl-re
        qbittorrent

        # Streaming
        # grayjay
      ]
    );
  };
}

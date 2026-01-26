{ globals, pkgs, ... }:
{
  nixpkgs.overlays = [
    (self: super: {
      mpv = super.mpv.override {
        scripts = [
          pkgs.mpvScripts.modernz
          pkgs.mpvScripts.thumbfast
          pkgs.mpvScripts.visualizer
        ];
      };
    })
  ];

  home-manager.users.${globals.user} = {
    xdg.configFile."mpv" = {
      source = ./config;
      recursive = true;
    };

    home.packages = (
      with pkgs;
      [
        mpv
      ]
    );
  };
}

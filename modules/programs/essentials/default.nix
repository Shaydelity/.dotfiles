{
  lib,
  globals,
  pkgs,
  ...
}:
{
  imports = [
    ./gui
    ./terminal
  ];

  home-manager.users.${globals.user} = {
    home.packages = (
      with pkgs;
      [
        appimage-run
        openssl
        gnupg
        wineWowPackages.stable

        # Git has its own config in modules/development/tools/git.nix.
        # However, since the flake needs git, it should always be available.
        git
      ]
    );

    # GPG
    home.file.".gnupg/gpg-agent.conf".text = ''
      pinentry-program ${pkgs.pinentry-gnome3}/bin/pinentry
    '';
  };

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  programs.appimage.package = pkgs.appimage-run.override {
    extraPkgs = pkgs: [
      pkgs.python312
    ];
  };

  # Make unmounted disks appear in dolphin
  services.udisks2.enable = true;
}

{
  lib,
  pkgs,
  globals,
  ...
}:
{
  imports = [
    ./languages
    ./tools
  ];

  home-manager.users.${globals.user} = {
    home.packages = (
      with pkgs;
      [
        sqlitebrowser
        pkg-config
        direnv
        go
        sqlite
        terraform
        packer
        kubectl
        hcloud
      ]
    );
  };
}

{
  pkgs,
  globals,
  ...
}:

{
  home-manager.users.${globals.user} = {
    services.flatpak.packages = [
      "io.github.MakovWait.Godots"
    ];
  };
}

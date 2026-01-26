{
  pkgs,
  globals,
  ...
}:

{
  home-manager.users.${globals.user} = {
    home.packages = (
      with pkgs;
      [
        clang
        gnumake
      ]
    );
  };
}

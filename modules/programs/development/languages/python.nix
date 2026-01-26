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
        (pkgs.python3.withPackages (python-pkgs: [
          python-pkgs.pip
        ]))
        uv
      ]
    );
  };
}

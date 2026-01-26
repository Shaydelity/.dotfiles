{
  lib,
  pkgs,
  globals,
  ...
}:
{
  home-manager.users.${globals.user} = {
    home.packages = (
      with pkgs;
      [
        # Advanced creation tools
        blender
        blockbench
        bitwig-studio
        davinci-resolve
        inkscape
        orca-slicer
      ]
    );
  };
}

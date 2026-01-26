{
  lib,
  globals,
  pkgs,
  ...
}:
{
  # Bluetooth
  services.blueman.enable = true;
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
    };
  };
  hardware.bluetooth.input = {
    General = {
      UserspaceHID = true;
    };
  };
  # Disable ertm
  boot.extraModprobeConfig = "options bluetooth disable_ertm=1 ";

  home-manager.users.${globals.user} = {
    home.packages = (
      with pkgs;
      [
        blueman
      ]
    );
  };
}

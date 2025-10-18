{ lib, ... }:
{
  # Internet
  networking.useDHCP = lib.mkDefault true;
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
  # networking.firewall.allowedUDPPorts = [ ${services.tailscale.port} ];
  #networking.nameservers = [
  #  "192.168.68.250"
  #  "1.1.1.1"
  #  "100.100.100.100"
  #];
  services.resolved.enable = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

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
  boot.extraModprobeConfig = ''options bluetooth disable_ertm=1 '';
}

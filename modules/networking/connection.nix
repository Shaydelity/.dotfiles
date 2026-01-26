{ lib, ... }:
{
  # Internet
  networking.useDHCP = lib.mkDefault true;
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
  # networking.firewall.allowedUDPPorts = [ ${services.tailscale.port} ];
  services.resolved.enable = true;
}

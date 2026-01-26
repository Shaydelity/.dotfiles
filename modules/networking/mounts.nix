{
  lib,
  pkgs,
  globals,
  ...
}:

{
  # Open Source implementation of the SMB and Active Directory protocols
  services.samba.enable = true;

  # Automount all removable devices (as sync)
  # "As sync" means that the Kernel Write Cache option won't be utilized,
  # making external removal safe.
  services.udisks2.enable = true;
  environment.systemPackages = with pkgs; [
    udiskie # Automatic Mounting
    sshfs # ssh filesystem support
  ];
  # Automounted devices are in /media
  systemd.tmpfiles.rules = [ "d /media 0755 root root -" ];
  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="sd[a-z][0-9]", ATTRS{removable}=="1", ENV{UDISKS_FILESYSTEM_SHARED}="1", ENV{UDISKS_MOUNT_OPTIONS_DEFAULTS}="sync"
  '';
}

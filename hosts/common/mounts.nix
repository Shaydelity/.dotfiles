{ lib, pkgs, ... }:

{
  # Samba
  # Windows Network Storage
  #services.samba.enable = true;

  # Kernel Write Cache Limiter
  # Reduces performance, only used to  mitigate dolphin local to online storage file transfer
  #boot.kernel.sysctl = {
  #  "vm.dirty_background_ratio" = 5;
  #  "vm.dirty_bytes" = "67108864";
  #  "vm.dirty_background_bytes" = "33554432";
  #};

  # TrueNAS
  #networking.extraHosts = ''
  #  truenas 192.168.68.76
  #'';

  #fileSystems = {
  #  "/mnt/truenas" = {
  #    device = "//truenas/shaydelity/";
  #    fsType = "cifs";
  #    options = let
  #      automountOpts = lib.concatStringsSep ","
  #        [ "x-systemd.requires=tailscaled.service"
  #          "x-systemd.automount"
  #          "uid=1000"
  #          "gid=100"
  #          "sync"
  #          "users"
  #          "noauto"
  #          "suid"
  #          "exec"
  #          "mfsymlinks"
  #          "nocase"
  #          "cache=loose"
  #          "x-systemd.idle-timeout=60"
  #          "x-systemd.device-timeout=10s"
  #          "x-systemd.mount-timeout=5s"
  #        ];
  #    in [ "${automountOpts},credentials=/home/shaydelity/.truenas-secrets" ];
  #  };
  #};

  # Automount all removable devices (as sync)
  # "As sync" means that the Kernel Write Cache option won't be utilized,
  # making external removal safe.
  services.udisks2.enable = true;
  environment.systemPackages = with pkgs; [ udiskie ];
  systemd.tmpfiles.rules = [ "d /media 0755 root root -" ];
  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="sd[a-z][0-9]", ATTRS{removable}=="1", ENV{UDISKS_FILESYSTEM_SHARED}="1", ENV{UDISKS_MOUNT_OPTIONS_DEFAULTS}="sync"
  '';
}

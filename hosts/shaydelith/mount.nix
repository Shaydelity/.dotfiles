{ config, pkgs, lib, ... }:
 
 {
  fileSystems."/mnt/T7" = {
    device = "/dev/disk/by-label/T7";
    fsType = "exfat";
    options = [ "uid=1000" "gid=100" "umask=0002""noatime" "nofail" ];
  };
 }

{ config, pkgs, lib, ... }:
 
 {
  fileSystems."/mnt/T7" = {
    device = "/dev/disk/by-label/T7";
    fsType = "exfat";
    options = [ "defaults" "noatime" "nofail" ];
  };
 }
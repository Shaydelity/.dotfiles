 
{ config, pkgs, zstd, ... }:

{
  imports = [
    ./hardware.nix
    ../common
  ];

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  networking.hostName = "eclipse"; # Define your hostname.

  virtualisation.docker.enable = true;

  #boot.kernelPackages = let
  #  linux_sgx_pkg = { stdenv, fetchFromGitHub, buildLinux, zstd, ... } @ args:

#    buildLinux (args // rec {
 #     version = "6.14.2";
  #    modDirVersion = version;

   #   nativeBuildInputs = [ zstd ];

    #  src = fetchFromGitHub {
      #  owner = "linux-surface";
     #   repo = "linux-surface";
       # rev = "79592057c0806943c6725cb776c30b5f5647d6b3";
       # sha256 = "sha256-9dawYAopzFYIbwH68zpBOw2Qty7iorRUyuO7jjnn9Bk="; # ← fill in after first build
      #};

      # kernelPatches = [];

      #extraConfig = ''
      #  INTEL_SGX y
      #'';

      #extraMeta.branch = "6.14";
#    } // (args.argsOverride or {}));

    #linux_sgx = pkgs.callPackage linux_sgx_pkg #{};
  #in
  #pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor #linux_sgx);
}


{ config, pkgs, zstd, ... }:

{
  #nixpkgs.overlays = [
    #(final: prev: {

    # From https://github.com/NixOS/nixpkgs/blob/69f966b3410d0f1caf97fb6dea639cef6fa15df4/pkgs/applications/misc/iptsd/default.nix#L18
#     iptsd = prev.iptsd.overrideAttrs (old: rec {
#
#       src = prev.fetchFromGitHub {
#         owner = "linux-surface";
#         repo = "iptsd";
#         rev = "b96c8e14c095a493240108606c37be1787094e0a";
#         hash = "sha256-zj01uV4Rya/MbIh44dQ6/w6KafTfIaPSK38ElD6gjEE=";
#       };
#
#       buildInputs = old.buildInputs ++ [ prev.cairomm prev.SDL2 ];
#       mesonFlags = [
#         "-Dservice_manager=systemd"
#         "-Dsample_config=false"
#         "-Ddebug_tools=calibrate,dump,perf,plot"
#         "-Db_lto=false" # plugin needed to handle lto object -> undefined reference to ...
#       ];
#     });
  #}
  #)
  #];

  environment.systemPackages = (with pkgs; [
      iptsd
  ]);
}

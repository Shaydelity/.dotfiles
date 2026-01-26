{
  config,
  pkgs,
  inputs,
  ...
}:
let
  # Hyprland mesa
  pkgs-hypr = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in

{
  # AMD graphics
  hardware.graphics = {
    enable = true;
    package = pkgs-hypr.mesa;
    extraPackages = with pkgs; [
      amf
      libva
      libvdpau-va-gl
      vulkan-loader
      vulkan-validation-layers
      mesa.opencl
      rocmPackages.clr
      rocmPackages.clr.icd
    ];
  };

  environment.systemPackages = with pkgs; [
    rocmPackages.rocminfo
    rocmPackages.rocm-smi
  ];

  nixpkgs.config = {
    # Enable ROCm support in packages
    rocmSupport = true;
  };

  # To see if it works:
  # nix-shell -p glxinfo --run "glxinfo -B"
}

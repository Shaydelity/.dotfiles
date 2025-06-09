{ config, lib, pkgs, ... }:
{
  programs.steam.enable = true;
  
  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [ vulkan-loader vulkan-validation-layers vulkan-extension-layer ];
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;
    open = true;
    modesetting.enable = true;
    nvidiaSettings = true;
  };
  
}


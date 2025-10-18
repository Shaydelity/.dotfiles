{ config, pkgs, pkgs-unstable, zstd, nix-flatpak, hyprland, inputs, ... }:

{
  imports = [
    ./hardware.nix
    ./nvidia.nix
    #./vr.nix
#     ./mount.nix
    ../common
  ];

  networking.hostName = "shaydelith"; # Define your hostname.

  programs.corectrl.enable = true;

  # Imports Home Manager
  home-manager.extraSpecialArgs = {inherit inputs;};
  home-manager.useUserPackages = true;
  home-manager.users.shaydelity = {
    imports = [
      hyprland.homeManagerModules.default
      nix-flatpak.homeManagerModules.nix-flatpak
      ../../home
    ];
  };

  # Home Manager Program Overrides
  home-manager.users.shaydelity.home.packages = [
    pkgs.bs-manager
  ];

  # Sample rate
  services.pipewire.extraConfig = {
    pipewire = {
      # Will create a config in /etc/pipewire/pipewire.conf.d/
      "10-custom-audio-rate" = {
        "context.properties" = {
          "default.clock.rate" = 192000; # Or 44100, 48000, 96000, 192000, etc.
          "resample.quality" = 10;
        };
      };
    };

  pipewire-pulse."10-pulse-192khz" = {
      "pulse.properties" = {
        "audio.channels" = 2;
        "audio.format" = "S32LE";
        "default.sample.rate" = 192000;
        "default.channels" = 2;
        "default.sample.format" = "S32LE";
      };
    };
  };

  # Version of 1st Install
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
  home-manager.users.shaydelity.home.stateVersion = "25.05";
}

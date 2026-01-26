{
  flake,
  inputs,
  flakeGlobals,
  ...
}:
let
  system = "x86_64-linux";

  # Packages Configuration
  pkgs = import inputs.nixpkgs {
    system = system;
    config.allowUnfree = true;
  };

  # Unstable Packages Configuration
  pkgs-unstable = import inputs.nixpkgs-stable {
    system = system;
    config.allowUnfree = true;
  };

  # Version of 1st Install
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  globals = flakeGlobals // {
    user = "shaydelity";
    hostname = "shaydelith";
    keyboard-layout = "de";
    first-install-version = "25.05";
  };
in
inputs.nixpkgs.lib.nixosSystem rec {
  specialArgs = {
    inherit flake inputs globals;
  };

  modules = [
    inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
    inputs.catppuccin.nixosModules.catppuccin
    inputs.nix-index-database.nixosModules.nix-index
    inputs.home-manager.nixosModules.home-manager
    inputs.lsfg-vk-flake.nixosModules.default

    ./hardware.nix

    "${flake}/hosts/common.nix"
    "${flake}/modules/hardware/graphics/nvidia.nix"

    "${flake}/modules/desktop"
    "${flake}/modules/hardware/device-support/drawing-tablet.nix"
    "${flake}/modules/hardware/device-support/3d-printing.nix"
    "${flake}/modules/hardware/device-support/printing.nix"
    "${flake}/modules/networking"
    "${flake}/modules/programs"
    "${flake}/modules/tmp.nix"

    {
      networking.hostName = globals.hostname;

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

      # Hyprland overrides
      home-manager.users.${globals.user} = {
        home.stateVersion = globals.first-install-verison;

        wayland.windowManager.hyprland.settings = {
          monitor = [
            "HDMI-A-1, 1920x1080@60, 0x1080, auto"
            "DP-1, 2560x1440@120, 1920x720, auto"
            "DP-2, 1920x1080@60, 4480x1080, auto"
          ];
        };
      };

      system.stateVersion = globals.first-install-verison;
    }
  ];
}

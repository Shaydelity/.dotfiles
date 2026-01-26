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
  pkgs-unstable = import inputs.nixpkgs-unstable {
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
    hostname = "nyx";
    keyboard-layout = "de";
    first-install-version = "25.11";
  };

  monitor_settings = {
    battery = "eDP-1, 1920x1200@60, auto, 1";
    charging = "eDP-1, 1920x1200@60, auto, 1";
  };
in
inputs.nixpkgs.lib.nixosSystem rec {
  specialArgs = {
    inherit
      flake
      inputs
      globals
      pkgs-unstable
      ;
  };

  modules = [
    #inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    #inputs.fw-fanctrl.nixosModules.default
    inputs.catppuccin.nixosModules.catppuccin
    inputs.nix-index-database.nixosModules.nix-index
    inputs.home-manager.nixosModules.home-manager
    inputs.lsfg-vk-flake.nixosModules.default

    ./hardware.nix # Automatically Generated Configuration for this Host.

    "${flake}/hosts/common.nix" # Universal, general, settings for all Hosts.
    "${flake}/modules/hardware/graphics/amd.nix" # AMD specific (which is present in FW Laptops), not graphicscard specific.

    "${flake}/modules/desktop"
    "${flake}/modules/hardware/device-support/printing.nix"
    "${flake}/modules/networking"
    "${flake}/modules/programs"
    "${flake}/modules/tmp.nix"
    {
      networking.hostName = globals.hostname;

      #hardware.framework.enableKmod = true;
      services.fwupd.enable = true;

      # Ignore the power key & suspend when laptop lid is closed
      services.logind.settings.Login = {
        HandleLidSwitch = "suspend";
        HandlePowerKey = "suspend";
        HandleSuspendKey = "ignore";
        HandleHibernateKey = "ignore";
      };

      services.fprintd.enable = true;

      # Latptop adjustments
      # services.cpupower-gui.enable = true;
      # powerManagement.cpuFreqGovernor = "schedutil";
      powerManagement.powertop.enable = true;
      services.thermald.enable = true;

      # Power Management
      # See https://gist.github.com/pauloromeira/787c75d83777098453f5c2ed7eafa42a
      services.power-profiles-daemon.enable = false;
      services.tlp = {
        enable = true;
        settings = {
          DISK_IDLE_SECS_ON_AC = 0;
          DISK_IDLE_SECS_ON_BAT = 2;

          MAX_LOST_WORK_SECS_ON_AC = 15;
          MAX_LOST_WORK_SECS_ON_BAT = 60;

          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

          CPU_HWP_ON_AC = "balance_performance";
          CPU_HWP_ON_BAT = "balance_power";

          SCHED_POWERSAVE_ON_AC = 0;
          SCHED_POWERSAVE_ON_BAT = 1;

          NMI_WATCHDOG = 0;

          ENERGY_PERF_POLICY_ON_AC = "performance";
          ENERGY_PERF_POLICY_ON_BAT = "powersave";

          PCIE_ASPM_ON_AC = "performance";
          PCIE_ASPM_ON_BAT = "powersave";

          RADEON_POWER_PROFILE_ON_AC = "high";
          RADEON_POWER_PROFILE_ON_BAT = "low";

          RADEON_DPM_STATE_ON_AC = "performance";
          RADEON_DPM_STATE_ON_BAT = "battery";

          RADEON_DPM_PERF_LEVEL_ON_AC = "auto";
          RADEON_DPM_PERF_LEVEL_ON_BAT = "low";

          # Wifi power saving
          #WIFI_PWR_ON_AC="off";
          #WIFI_PWR_ON_BAT="on";
          #WOL_DISABLE="Y";

          SOUND_POWER_SAVE_ON_AC = 0;
          SOUND_POWER_SAVE_ON_BAT = 1;
          SOUND_POWER_SAVE_CONTROLLER = "Y";

          RUNTIME_PM_ON_AC = "on";
          RUNTIME_PM_ON_BAT = "auto";

          USB_AUTOSUSPEND = 1;

          # Autosuspend: 0=do not exclude, 1=exclude
          USB_BLACKLIST_BTUSB = 0;
          USB_BLACKLIST_PHONE = 0;
          USB_BLACKLIST_WWAN = 1;

          START_CHARGE_THRESH_BAT0 = 90;
          STOP_CHARGE_THRESH_BAT0 = 97;

          CPU_BOOST_ON_AC = 1;
          CPU_BOOST_ON_BAT = 0;
        };
      };

      networking.networkmanager.wifi.powersave = true;

      # Home Manager overrides
      home-manager.users.${globals.user} = {
        home.stateVersion = "25.05";
        wayland.windowManager.hyprland.settings = {
          exec = [
            # Fix backlight
            "sudo chmod a+rw /sys/class/backlight/amdgpu_bl1/brightness"
            # Update charging status
            "sudo systemctl start charger"
          ];

          monitor = [
            "${monitor_settings.battery}"
          ];
        };
      };

      # Mind the Description.
      systemd.services."charger" = {
        description = "Adjust Hyprland settings based on AC power status";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "charger-handler" ''
            ${pkgs.util-linux}/bin/runuser -u ${globals.user} -- ${pkgs.bash}/bin/bash -c '
              charging=$(cat /sys/class/power_supply/ACAD/online 2>/dev/null || echo 0)
              export XDG_RUNTIME_DIR="/run/user/$(id -u)"
              export WAYLAND_DISPLAY="wayland-1"

              # Find the directory that actually contains a Hyprland socket
              instance=$(find "$XDG_RUNTIME_DIR/hypr" -type s -name ".socket.sock" -printf "%h\n" 2>/dev/null | head -n1)

              if [ -z "$instance" ]; then
                echo "No active Hyprland socket found" >&2
                exit 1
              fi

              export HYPRLAND_INSTANCE_SIGNATURE=$(basename "$instance")
              echo "Using Hyprland instance: $HYPRLAND_INSTANCE_SIGNATURE"

              if [ "$charging" = "1" ]; then
                ${pkgs.hyprland}/bin/hyprctl keyword monitor "${monitor_settings.charging}"
                ${pkgs.hyprland}/bin/hyprctl keyword animations:enabled 1
                ${pkgs.hyprland}/bin/hyprctl keyword decoration:blur:enabled 1
              else
                ${pkgs.hyprland}/bin/hyprctl keyword monitor "${monitor_settings.battery}"
                ${pkgs.hyprland}/bin/hyprctl keyword animations:enabled 0
                ${pkgs.hyprland}/bin/hyprctl keyword decoration:blur:enabled 0
              fi
            '
          '';
        };
      };

      # Triggers systemd.services."charger", which is defined above.
      services.udev.extraRules = ''
        SUBSYSTEM=="power_supply", KERNEL=="ACAD", \
          ENV{POWER_SUPPLY_ONLINE}=="0", \
          RUN+="${pkgs.systemd}/bin/systemctl --no-block start charger.service"
        SUBSYSTEM=="power_supply", KERNEL=="ACAD", \
          ENV{POWER_SUPPLY_ONLINE}=="1", \
          RUN+="${pkgs.systemd}/bin/systemctl --no-block start charger.service"
      '';

      # Version of first install
      system.stateVersion = globals.first-install-version;
    }
  ];
}

{ config, pkgs, zstd, nix-flatpak, hyprland, inputs, ... }:

{
  imports = [
    ./hardware.nix
    ../common
  ];
  # Device Name
  networking.hostName = "eclipse"; # Define your hostname.

  # Import Home Manager
  home-manager.extraSpecialArgs = {inherit inputs;};
  home-manager.useUserPackages = true;
  home-manager.users.shaydelity = {
    imports = [
      hyprland.homeManagerModules.default
      nix-flatpak.homeManagerModules.nix-flatpak
      ../../home/eclipse.nix
    ];
  };

  # Bluetooth on Boot
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  services.iptsd.enable = true;

  # Suspend when laptop lid is closed
  #services.logind = {
  #  lidSwitch = "suspend";
  #};

  # Ignore the power key
  #services.logind.settings.Login = {
  #  HandlePowerKey = "ignore";    HandleSuspendKey = "ignore";
  #  HandleHibernateKey = "ignore";
  #};

  # Laptop Optimization
  #services.cpupower-gui.enable = true;
  #powerManagement.cpuFreqGovernor = "schedutil";
  powerManagement.powertop.enable = true;
  services.thermald.enable = true;

  # See https://gist.github.com/pauloromeira/787c75d83777098453f5c2ed7eafa42a
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      DISK_IDLE_SECS_ON_AC=0;
      DISK_IDLE_SECS_ON_BAT=2;

      MAX_LOST_WORK_SECS_ON_AC=15;
      MAX_LOST_WORK_SECS_ON_BAT=60;

      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_HWP_ON_AC="balance_performance";
      CPU_HWP_ON_BAT="balance_power";

      SCHED_POWERSAVE_ON_AC=0;
      SCHED_POWERSAVE_ON_BAT=1;

      NMI_WATCHDOG=0;

      ENERGY_PERF_POLICY_ON_AC="performance";
      ENERGY_PERF_POLICY_ON_BAT="powersave";

      PCIE_ASPM_ON_AC="performance";
      PCIE_ASPM_ON_BAT="powersave";

      RADEON_POWER_PROFILE_ON_AC="high";
      RADEON_POWER_PROFILE_ON_BAT="low";

      RADEON_DPM_STATE_ON_AC="performance";
      RADEON_DPM_STATE_ON_BAT="battery";

      RADEON_DPM_PERF_LEVEL_ON_AC="auto";
      RADEON_DPM_PERF_LEVEL_ON_BAT="low";

      # Wifi power saving
      #WIFI_PWR_ON_AC="off";
      #WIFI_PWR_ON_BAT="on";
      #WOL_DISABLE="Y";

      SOUND_POWER_SAVE_ON_AC=0;
      SOUND_POWER_SAVE_ON_BAT=1;
      SOUND_POWER_SAVE_CONTROLLER="Y";

      RUNTIME_PM_ON_AC="on";
      RUNTIME_PM_ON_BAT="auto";

      USB_AUTOSUSPEND=1;

      # Autosuspend: 0=do not exclude, 1=exclude
      USB_BLACKLIST_BTUSB=0;
      USB_BLACKLIST_PHONE=0;
      USB_BLACKLIST_WWAN=1;

      START_CHARGE_THRESH_BAT0 = 90;
      STOP_CHARGE_THRESH_BAT0 = 97;

      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
    };
  };

  boot.kernelParams = [
    "radeon.dpm=1"  # needed for tlp RADEON_DPM_STATE

    # Tickless / scheduler tuning
    "nohz_full=1-12"          # Replace N with your last CPU (exclude CPU0)
    "rcu_nocbs=1-12"          # Offload RCU callbacks from isolated CPUs
    # AMD GPU power management
    "amdgpu.dc=1"
    "amdgpu.deep_color=1"
    "amdgpu.runpm=1"

    "ahci.mobile_lpm_policy=3"
    "rtc_cmos.use_acpi_alarm=1"
  ];

  networking.networkmanager.wifi.powersave = false;

  # Home Manager overrides
  home-manager.users.shaydelity.wayland.windowManager.hyprland.settings = {
    exec = [
      # Update charging status
      "sudo systemctl start charger"
    ];

    #monitor = [
      # Also update this in the systemd charger service.
    #  "eDP-1, 2880x1920@120, auto, auto"
    #];
  };

  # Disable Hyprland Animations
  systemd.services."charger" = {
    description = "Run commands based on charging status - gets called by udev rules & on hyprland load/reload.";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "charger-handler" ''
        # Set env variables to access user stuff
        export XDG_RUNTIME_DIR="/run/user/1000"
        export WAYLAND_DISPLAY="wayland-1"
        export HYPRLAND_INSTANCE_SIGNATURE=$(ls "$XDG_RUNTIME_DIR/hypr/")

        charging=$(cat /sys/class/power_supply/ACAD/online)

        if [ "$charging" = "1" ]; then
          ${pkgs.hyprland}/bin/hyprctl keyword monitor "eDP-1, 2880x1920@120, auto, auto"
          ${pkgs.hyprland}/bin/hyprctl keyword animations:enabled 1
          ${pkgs.hyprland}/bin/hyprctl keyword decoration:blur:enabled 1
        else
          ${pkgs.hyprland}/bin/hyprctl keyword monitor "eDP-1, 2880x1920@60, auto, auto"
          ${pkgs.hyprland}/bin/hyprctl keyword animations:enabled 0
          ${pkgs.hyprland}/bin/hyprctl keyword decoration:blur:enabled 0
        fi
      '';
    };
  };

  # Start the above defined service.
  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", KERNEL=="ACAD", \
      ENV{POWER_SUPPLY_ONLINE}=="0", \
      RUN+="${pkgs.systemd}/bin/systemctl --no-block start charger.service"
    SUBSYSTEM=="power_supply", KERNEL=="ACAD", \
      ENV{POWER_SUPPLY_ONLINE}=="1", \
      RUN+="${pkgs.systemd}/bin/systemctl --no-block start charger.service"
  '';


  # Version of 1st Install
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
  home-manager.users.shaydelity.home.stateVersion = "25.05";
}


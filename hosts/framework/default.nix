{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../common
  ];

  networking.hostName = "framework";

  hardware.framework.enableKmod = true;
  services.fwupd.enable = true;

  # Suspend when laptop lid is closed
  services.logind = {
    lidSwitch = "suspend";
  };

  # Ignore the power key
  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
    HandleSuspendKey=ignore
    HandleHibernateKey=ignore
  '';

  # Latptop adjustments
  services.cpupower-gui.enable = true;
  powerManagement.cpuFreqGovernor = "schedutil";
  services.power-profiles-daemon.enable = false;  # Conflicts with tlp
  powerManagement.powertop.enable = true;
  services.thermald.enable = true;
  services.tlp = {
      enable = false;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;

       #Optional helps save long term battery health
       START_CHARGE_THRESH_BAT0 = 80;
       STOP_CHARGE_THRESH_BAT0 = 95;

      };
  };

  services.auto-cpufreq.enable = true; # Might conflict with tlp, but is allowed to be used at the same time.
  services.auto-cpufreq.settings = {
    battery = {
       governor = "powersave";
       turbo = "never";
    };
    charger = {
       governor = "performance";
       turbo = "auto";
    };
  };


  # Enable fw-fanctrl (framework fancontrol)
  programs.fw-fanctrl.enable = true;

  # Add a custom config
  programs.fw-fanctrl.config = {
    defaultStrategy = "lazy";
    strategies = {
      "lazy" = {
        fanSpeedUpdateFrequency = 5;
        movingAverageInterval = 30;
        speedCurve = [
          { temp = 0; speed = 0; }
          { temp = 40; speed = 15; }
          { temp = 65; speed = 25; }
          { temp = 70; speed = 35; }
          { temp = 75; speed = 50; }
          { temp = 85; speed = 100; }
        ];
      };
    };
  };
}

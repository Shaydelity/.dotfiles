{
  ...
}:

{
  # Drawing tablets
  hardware.opentabletdriver.enable = true;
  hardware.opentabletdriver.daemon.enable = true;
  boot.blacklistedKernelModules = [
    "wacom"
    "hid_uclogic"
  ];
}

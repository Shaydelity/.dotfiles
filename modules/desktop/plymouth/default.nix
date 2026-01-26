{ pkgs, ... }:
let
  framework-theme-pkg = pkgs.callPackage ./package.nix { };
in
{
  boot = {
    plymouth = {
      enable = true;
      theme = "framework"; # See package.nix for credits.
      themePackages = with pkgs; [
        framework-theme-pkg
        # (adi1090x-plymouth-themes.override {
        #   selected_themes = [ "hexagon_hud" ];
        # })
      ];
    };

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "systemd.show_status=auto"
    ];

    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 0;
  };
}

{
  config,
  pkgs,
  globals,
  ...
}:
let
  rofi-main-menu = pkgs.writeShellScriptBin "rofi-main-menu" ''
    chosen=$(printf "Sound\nNetwork\nBluetooth\nPower" | rofi -dmenu -p "Main")

    case "$chosen" in
      "Sound")
        pavucontrol
        ;;
      "Network")
        networkmanager_dmenu &
        ;;
      "Bluetooth")
        rofi-bluetooth &
        ;;
      "Power")
        rofi -show power-menu -modi power-menu:rofi-power-menu
        ;;
    esac
  '';
in
{
  home-manager.users.${globals.user} = {
    home.packages = with pkgs; [
      rofi
      rofi-power-menu
      networkmanager_dmenu

      rofi-top
      rofi-rbw-wayland # Bitwarden
      rofi-bluetooth
      rofi-main-menu
    ];

    xdg.configFile."rofi" = {
      source = ./config;
      recursive = true;
    };

    # Disable the cache by making the file readonly.
    home.file.".cache/rofi-drun-desktop.cache".text = "";
  };
}

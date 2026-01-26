{
  pkgs,
  lib,
  inputs,
  globals,
  ...
}:
{
  imports = [
    ./mako
    ./rofi
    ./waybar
  ];

  services.displayManager.gdm.enable = true;

  #xdg.portal = {
  #  enable = true;
  #  extraPortals = with pkgs; [
  #    # (config.lib.nixGL.wrap xdg-desktop-portal-hyprland)
  #    # xdg-desktop-portal-wlr
  #    xdg-desktop-portal-gtk
  #  ];
  # config = {
  #   hyprland.default = [ "hyprland" "gtk" ];
  # };
  #};

  # Enable Hyprland
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  };
  services.gnome.gnome-keyring.enable = true;
  programs.dconf.enable = true;

  # Configure Hyprland
  home-manager.users.${globals.user} = {
    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      xwayland.enable = true;
      systemd.enable = true;

      #plugins = [
      #inputs.split-monitor-workspaces.packages.${pkgs.stdenv.hostPlatform.system}.split-monitor-workspaces
      #];

      settings = {
        exec-once = [
          "hyprctl setcursor Bibata-Modern-Classic 24"
          "dunst"
          "easyeffects --gapplication-service"
          "systemctl --user start hyprpolkitagent"
          "hyprpaper"
          "udiskie --automount --notify"
        ];

        exec = [
          "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          "dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          "pkill waybar; waybar"
          "XDG_MENU_PREFIX=plasma- kbuildsycoca6"
        ];

        input = {
          kb_layout = globals.keyboard-layout;
          follow_mouse = 1;
          sensitivity = 1.0;
          accel_profile = "flat";
          force_no_accel = true;
          natural_scroll = false;

          touchpad = {
            natural_scroll = true;
            disable_while_typing = false;
            scroll_factor = 0.8;
          };
        };

        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          "col.active_border" = "rgba(e170ffee) rgba(70a0ffee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";
          layout = "dwindle";
        };

        decoration = {
          rounding = 10;
          blur = {
            enabled = true;
          };
          shadow = {
            enabled = false;
          };
        };

        animations = {
          enabled = true;

          bezier = [
            "ease,0.4,0.02,0.21,1"
          ];

          animation = [
            "windows,1,3.5,ease,popin"
            "windowsOut,1,3.5,ease,popin"
            "border,1,6,default"
            "fade,1,3,ease"
            "workspaces,1,3.5,ease,slidefade"
          ];
        };

        xwayland = {
          force_zero_scaling = false;
        };

        misc = {
          vfr = true; # Lower framerate when no movement.
        };

        render = {
          direct_scanout = 0;
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        #gestures = {
        #  workspace_swipe = false;
        #};

        #plugin = {
        #"split-monitor-workspaces" = {
        #count = 10;
        #keep_focused = true;
        #enable_notifications = false;
        #enable_persistent_workspaces = false;
        #};
        #};

        windowrule = [
          # Fix JetBrains context menus
          "match:class ^jetbrains-.*$, float on, no_initial_focus on"

          # Pavucontrol
          "match:class ^org.pulseaudio.pavucontrol$, float on"
          "match:class ^org.pulseaudio.pavucontrol$, size 800 600"
          "match:class ^org.pulseaudio.pavucontrol$, workspace unset"

          # Nemo file manager properties window
          "match:class ^nemo$, match:title .*Properties$, float on"

          # Grayjay (tile)
          "match:title ^Grayjay$, tile on"

          # Fix pinentry losing focus (keep focus while visible)
          "match:class ^pinentry-.*, stay_focused on"

          # Fix Bitwig sliders
          "match:class ^$, match:title ^$, match:xwayland true, float on, no_focus on, fullscreen off, pin off"
        ];

        "$mainMod" = "SUPER";

        bind = [
          "$mainMod ALT, 1, exec, hyprctl keyword input:kb_layout de" # Switch to German (QWERTZ)
          "$mainMod ALT, 2, exec, hyprctl keyword input:kb_layout gr"
          "$mainMod ALT, 2, exec, hyprctl keyword input:kb_layout, extended" # Switch to Greek with variant "extended" (closest to Latin punctuation)
          "$mainMod ALT, 3, exec, hyprctl keyword input:kb_layout jp" # Switch to Japanese (IME mode handled separately)
          "$mainMod, F, fullscreen" # "F for Fullscreen."
          "$mainMod, RETURN, exec, kitty" # "Enter text/terminal."
          "$mainMod, T, exec, kitty" # "T for Terminal."
          "$mainMod, Q, killactive" # "Q for Quit (window)."
          "$mainMod, X, exec, rofi -show power-menu -modi power-menu:~/.dotfiles/modules/desktop/hypr/rofi/config/rofi-power-menu" # "X for Exit."
          #             "$mainMod, I, exec, rofi-main-menu" # Meta + I is the Windows shortcut for settings.
          "$mainMod, E, exec, dolphin" # "E for Explorer."
          "$mainMod, SPACE, togglefloating" # "You float in space."
          "$mainMod, d, exec, rofi -theme theme -show drun" # Uses rofi; "D for Desktop-run/DRun"
          "$mainMod, L, togglesplit" # Uses dwindle; "L like Layout"

          "$mainMod SHIFT, S, exec, grim -g \"$(slurp -d)\" - | wl-copy" # Windows shortcut for screenshots.
          #             "$mainMod SHIFT, S, exec, spectacle -r" # Windows shortcut for screenshots.
          #             "$mainMod SHIFT, S, exec, hyprshot -m region -c"
          "$mainMod CONTROL, S, exec, grim -g \"$(slurp -d)\" - | swappy -f -"
          "$mainMod ALT, S, exec, grim - | wl-copy"

          # Functional keybinds
          ",XF86AudioMicMute,exec,pamixer --default-source -t"
          ",XF86MonBrightnessDown,exec,bash brightness - 5"
          ",XF86MonBrightnessUp,exec,bash brightness + 5"
          ",XF86AudioMute,exec,pamixer -t"
          ",XF86AudioLowerVolume,exec,pamixer -d 5"
          ",XF86AudioRaiseVolume,exec,pamixer -i 5"
          ",XF86AudioPlay,exec,playerctl play-pause"
          ",XF86AudioPause,exec,playerctl play-pause"

          # to switch between windows in a floating workspace
          "$mainMod,Tab,cyclenext"
          "$mainMod,Tab,bringactivetotop"
          "$mainMod SHIFT,Tab,cyclenext, prev" # Let's you cycle back one time
          "$mainMod SHIFT,Tab,bringactivetotop"

          # Move focus with mainMod + arrow keys
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"

          # Switch workspaces with mainMod + [0-9]
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"

          # Switch workspace
          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"

          # Move active window within workspace
          "$mainMod SHIFT, LEFT, movewindow, l"
          "$mainMod SHIFT, RIGHT, movewindow, r"
          "$mainMod SHIFT, UP, movewindow, u"
          "$mainMod SHIFT, DOWN, movewindow, d"

          # Resize with arrow keys
          "$mainMod CONTROL, LEFT, resizeactive, -30 0"
          "$mainMod CONTROL, RIGHT, resizeactive, 30 0"
          "$mainMod CONTROL, UP, resizeactive, 0 -30"
          "$mainMod CONTROL, DOWN, resizeactive, 0 30"
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
          "ALT, mouse:272, resizewindow"
        ];
      };
    };

    services.hypridle = {
      enable = true;
      settings = {
        after_sleep_cmd = "sudo systemctl restart NetworkManager";
        inhibit_sleep = 1;
      };
    };

    services.hyprpolkitagent.enable = true;

    services.clipman.enable = true;
    home.packages = with pkgs; [
      xdg-desktop-portal
      grim
      swappy
      slurp # Screenshot Cropping
      hyprlock
      hyprpaper
      swww
      pavucontrol
      easyeffects
      wl-clipboard
      pamixer
      xclip # X11 Clipboard
      clipnotify # Needed for Clipsync script
      # cliphist
      pamixer
      networkmanagerapplet
      papirus-folders
      xorg.xhost
      xwayland
    ];

    home = {
      sessionVariables = {
        EDITOR = "kate";
        BROWSER = "firefox";
        TERMINAL = "kitty";
        __GL_VRR_ALLOWED = "1";
        # WLR_NO_HARDWARE_CURSORS = "1";
        WLR_RENDERER_ALLOW_SOFTWARE = "1";
        CLUTTER_BACKEND = "wayland";
        WLR_RENDERER = "vulkan";

        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_DESKTOP = "Hyprland";
        XDG_SESSION_TYPE = "wayland";
        NIXOS_OZONE_WL = "1";
        PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
        # AQ_DRM_DEVICES = "/dev/dri/card0:/dev/dri/card1";
        QT_STYLE_OVERRIDE = "darkly";
      };
    };

    gtk = {
      enable = true;
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };

      theme = {
        name = "catppuccin-mocha-mauve-standard";
        package = (
          pkgs.catppuccin-gtk.override {
            accents = [ "mauve" ];
            variant = "mocha";
          }
        ); # tokyo-night-gtk
      };

      cursorTheme = {
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
      };
    };

    qt = {
      enable = true;
      style.package = with pkgs; [
        darkly-qt5
        darkly
        catppuccin-qt5ct
        catppuccin
        dracula-qt5-theme
        dracula-theme
      ];
      platformTheme.name = "hyprqt6engine";
      kde.settings.kdeglobals.General.TerminalApplication = "kitty";
      kde.settings.kdeglobals.Icons.Theme = "Papirus-Dark";
      kde.settings.kdeglobals.UiSettings.ColorScheme = "qt6ct";
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };

      "org/gnome/shell/extensions/user-theme" = {
        name = "catppuccin-mocha-mauve-standard";
      };
    };

    xdg.configFile."hypr" = {
      source = ./config;
      recursive = true;
    };

    xdg.configFile."hypr/hyprpaper.conf".text = ''
      wallpaper {
        monitor =
        path = ${globals.install-dir}/assets/wallpapers/AmuHeraheran.jpg
      }
    '';
  };
}

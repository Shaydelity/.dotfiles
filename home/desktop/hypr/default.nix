{ pkgs, lib, ... }:
{
#home.activation = {
#    hypr_reload = lib.hm.dag.entryAfter ["writeBoundary"] ''
#        ${pkgs.hyprland}/bin/hyprctl reload
#    '';
#};

wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
        # Config stored externally!
    '';
};


home.packages = with pkgs; [
    xdg-desktop-portal
    grim
    slurp  # Screenshots
    hyprlock
    swww
    pavucontrol
    playerctl
    wl-clipboard
    pamixer
    hyprland-monitor-attached
    networkmanagerapplet

    # See hyprland config for applying qt theme.
    # plasma-apply-colorscheme CatppuccinMochaMauve
    (catppuccin-kde.override {
        flavour = [ "mocha" ];
        accents = [ "mauve" ];
    })
    # plasma-workspace
    libsForQt5.plasma-workspace

    papirus-folders
];


# To disable dolphin single click, add
# "SingleClick=false" to the [KDE] section in ~/.config/kdeglobals
qt = {
    enable = true;
    platformTheme.name = "kde";
};

home.activation.qt-theme = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run ${pkgs.libsForQt5.plasma-workspace}/bin/plasma-apply-colorscheme CatppuccinMochaMauve
'';


home = {
    sessionVariables = {
        EDITOR = "kate";
        BROWSER = "firefox";
        TERMINAL = "kitty";
        __GL_VRR_ALLOWED="1";
        WLR_NO_HARDWARE_CURSORS = "1";
        WLR_RENDERER_ALLOW_SOFTWARE = "1";
        CLUTTER_BACKEND = "wayland";
        WLR_RENDERER = "vulkan";

        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_DESKTOP = "Hyprland";
        XDG_SESSION_TYPE = "wayland";
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
        package = (pkgs.catppuccin-gtk.override {
            accents = [ "mauve" ];
            variant = "mocha";
        });  # tokyo-night-gtk
    };

    cursorTheme = {
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
    };
};

dconf.settings = {
    "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
    };

    "org/gnome/shell/extensions/user-theme" = {
        name = "Tokyonight-Dark";
    };
};

home.file.".config/hypr" = {
    source = ./config;
    recursive = true;
};

xdg.mimeApps = {
    enable = true;
    defaultApplications = {
        "default-web-browser" = [ "vivaldi-stable.desktop" ];
        "text/html" = [ "vivaldi-stable.desktop" ];
        "x-scheme-handler/http" = [ "vivaldi-stable.desktop" ];
        "x-scheme-handler/https" = [ "vivaldi-stable.desktop" ];
        "x-scheme-handler/about" = [ "vivaldi-stable.desktop" ];
        "x-scheme-handler/unknown" = [ "vivaldi-stable.desktop" ];
    };
};

#wayland.windowManager.hyprland = {
#    enable = true;
#    systemd.enable = true;
#    extraConfig = "";
#};
}

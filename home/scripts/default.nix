{ config, lib, pkgs, ... }:
let
  # https://github.com/hyprwm/Hyprland/issues/6132#issue-comment-2127153823
  #!/usr/bin/env sh
  clipsync = pkgs.writeShellScriptBin "clipsync" ''
    insert() {
    value=$(cat)
    wValue="$(wl-paste)"
    xValue="$(xclip -o -selection clipboard)"

    notify() {
        notify-send -u low -c clipboard "$1" "$value"
    }

    if [ "$value" != "$wValue"]; then
        notify "Wayland"
        echo -n "$value" | wl-copy
    fi

    if [ "$value" != "$xValue"]; then
        notify "X11"
        echo -n "$value" | xclip -selection clipboard
    fi
    }

    watch() {
        # Wayland -> X11
        wl-paste --type text --watch clipsync insert &

        # X11 -> Wayland
        while clipnotify; do
            xclip -o -selection clipboard | clipsync insert
        done &
    }

    kill() {
        pkill wl-paste
        pkill clipnotify
        pkill xclip
        pkill clipsync
    }

    "$@"
  '';

  rebuild = pkgs.writeShellScriptBin "rebuild" ''
  sudo nixos-rebuild $1 --flake ~/.dotfiles#$(hostname)
  '';


  cava-internal = pkgs.writeShellScriptBin "cava-internal" ''
    cava -p ~/.config/cava/config1 | sed -u 's/;//g;s/0/▁/g;s/1/▂/g;s/2/▃/g;s/3/▄/g;s/4/▅/g;s/5/▆/g;s/6/▇/g;s/7/█/g;'
  '';

  wallpaper_random = pkgs.writeShellScriptBin "wallpaper_random" ''
  bash -c "swww img $(find ~/.config/home-manager/wallpapers/ -type f | shuf -n 1)"
  '';

in
{
  home.packages = with pkgs; [
    clipsync
    rebuild
    cava-internal
    wallpaper_random
  ];
}


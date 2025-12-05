{ config, lib, pkgs, ... }:
let
    rust_create_project = pkgs.writeShellScriptBin "rust_create_project" ''
    nix --accept-flake-config run github:juspay/omnix -- init github:srid/rust-nix-template -o $1
  '';

  lock_and_sleep = pkgs.writeShellScriptBin "lock_and_sleep" ''
    hyprlock & systemctl suspend
  '';

  remount_force_all = pkgs.writeShellScriptBin "remount_force_all" ''
    sudo umount -l /mnt/*
    rebuild test
  '';

  wallpaper_random = pkgs.writeShellScriptBin "wallpaper_random" ''
  bash -c "swww img $(find ~/.config/home-manager/wallpapers/ -type f | shuf -n 1)"
  '';

  aniworld = pkgs.writeShellScriptBin "aniworld" ''
    nix-shell -p pipx yt-dlp --run "pipx install aniworld && /home/shaydelity/.local/bin/aniworld"
  '';

  ytdl = pkgs.writeShellScriptBin "ytdl" ''
    nix-shell -p yt-dlp --run "yt-dlp '$1' --add-metadata --cookies cookies.txt --embed-thumbnail -o '%(channel)s/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s'"
  '';


  hdmiplay = pkgs.writeShellScriptBin "hdmiplay" ''
    # Old version (Benefits from MPV upscaling shaders, but way more input lag on bad hardware.)
    # mpv av://v4l2:$1 --demuxer=lavf --demuxer-lavf-o=video_size=1280x720,framerate=60,input_format=mjpeg --profile=low-latency --keepaspect=no --vf="hqdn3d=3.0:2.0:4.0:3.0,pp=lb,unsharp=5:5:0.8"
    set -u
    shopt -s nullglob

    PW_LOOPBACK_NAME="alsa_input.usb-MACROSILICON_USB3.0_Capture-02.analog-stereo"

    # normalize argument: allow "0" or "/dev/video0"
    resolve_device_arg() {
        arg="$1"
        case "$arg" in
            [0-9]*) echo "/dev/video$arg" ;;
            *)      echo "$arg" ;;
        esac
    }

    # probe a device quickly with ffmpeg
    test_device() {
    dev="$1"

    # Must be a character device; if not, return 1 (error)
    [ -c "$dev" ] || return 1

    # Run ffmpeg probe, discarding all output.
    # The exit status is what matters.
    ffmpeg -hide_banner -loglevel error \
           -f v4l2 -video_size 1280x720 -framerate 60 -input_format mjpeg \
           -i "$dev" -frames:v 1 -f null - > /dev/null 2>&1

    # Return the exit status of the ffmpeg command.
    # 0 = success, non-zero = failure.
    return $?
}


    # pick device
    if [ $# -gt 0 ]; then
        DEV="$(resolve_device_arg "$1")"
        echo "Using provided device: $DEV"
        if ! test_device "$DEV"; then
            echo "ERROR: provided device '$DEV' failed probe." >&2
            exit 1
        fi
    else
        echo "No device supplied, probing /dev/video*..."
        DEV=""
        for d in /dev/video*; do
            echo -n " Testing $d ... "
            if test_device "$d"; then
                DEV="$d"
                echo "OK"
                echo "Using device: $DEV"
                break
            else
                echo "fail"
            fi
        done
        if [ -z "$DEV" ]; then
            echo "No usable video device found." >&2
            exit 1
        fi
    fi

    # start PipeWire loopback in background
    pw-loopback -C "$PW_LOOPBACK_NAME" &
    PW_PID=$!

    # clean up on exit
    trap 'kill "$PW_PID" 2>/dev/null || true' EXIT

    # 720p, yes. It gets a bit laggy at higher resolutions. I tried using this for Switch and it honestly looks good enough.
    ffplay -f v4l2 -video_size 1280x720 -framerate 60 \
       -input_format mjpeg \
       -fflags nobuffer -flags low_delay \
       -probesize 32 -analyzeduration 0 \
       -framedrop -fs "$DEV"
  '';

  brightness = pkgs.writeShellScriptBin "brightness" ''
    # Taken from https://github.com/MasterDevX/linux-backlight-controller/tree/master
    backlight_class=/sys/class/backlight/
    monitor=DP-1

    for device in $backlight_class*; do
        if ls -l $device | grep -q $monitor; then
            backlight_device=$device
            break
        fi
    done

    actual_brightness=$(cat $backlight_device/brightness)
    max_brightness=$(cat $backlight_device/max_brightness)
    brightness=$backlight_device/brightness

    step=$(($max_brightness * $2 / 100))
    if [ $1 == "+" ] || [ $1 == "-" ]; then
        new_brightness=$(($actual_brightness $1 $step))
        if [ $new_brightness -lt 0 ]; then
            new_brightness=0
        fi
        if [ $new_brightness -gt $max_brightness ]; then
            new_brightness=$max_brightness
        fi
        echo $new_brightness > $brightness
    fi
  '';


in
{
  home.packages = with pkgs; [
    lock_and_sleep
    remount_force_all
    wallpaper_random
    aniworld
    ytdl
    hdmiplay
    brightness
    rust_create_project
  ];
}


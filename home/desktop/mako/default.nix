{ config, lib, pkgs, ... }:

{
home.packages = with pkgs; [
    libnotify
];

services.mako = {
    enable = true;
};

home.file.".config/mako" = {
    source = ./config;
    recursive = true;
};

}

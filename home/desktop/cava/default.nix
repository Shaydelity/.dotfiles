{ config, pkgs, ... }:
{
home.packages = with pkgs; [
    cava
];

home.file.".config/cava" = {
    source = ./config;
    recursive = true;
};


}

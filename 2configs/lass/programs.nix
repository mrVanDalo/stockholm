{ config, pkgs, ... }:

## TODO sort and split up
{
  environment.systemPackages = with pkgs; [
    aria2
    gnupg1compat
    htop
    i3lock
    mc
    mosh
    mpv
    pass
    pavucontrol
    pv
    pwgen
    python34Packages.livestreamer
    remmina
    silver-searcher
    wget
    xsel
    youtube-dl
  ];
}

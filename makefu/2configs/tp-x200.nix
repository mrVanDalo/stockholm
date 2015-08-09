{ config, lib, pkgs, ... }:

with lib;
{
  #services.xserver = {
  #  videoDriver = "intel";
  #};

  boot = {
    kernelModules = [ "tp_smapi" "msr" ];
    extraModulePackages = [ config.boot.kernelPackages.tp_smapi ];

  };

  networking.wireless.enable = true;

  hardware.enableAllFirmware = true;
  nixpkgs.config.allowUnfree = true;

  hardware.trackpoint.enable = true;
  hardware.trackpoint.sensitivity = 255;
  hardware.trackpoint.speed = 255;
  services.xserver.displayManager.sessionCommands = ''
    xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation" 1
    xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Button" 2
    xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Timeout" 200
  '';
}

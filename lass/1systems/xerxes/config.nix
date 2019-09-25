{ config, lib, pkgs, ... }:

{
  imports = [
    <stockholm/lass>

    <stockholm/lass/2configs/retiolum.nix>
    <stockholm/lass/2configs/exim-retiolum.nix>
    <stockholm/lass/2configs/baseX.nix>
    <stockholm/lass/2configs/browsers.nix>
    <stockholm/lass/2configs/programs.nix>
    <stockholm/lass/2configs/network-manager.nix>
    <stockholm/lass/2configs/syncthing.nix>
    <stockholm/lass/2configs/games.nix>
    <stockholm/lass/2configs/steam.nix>
    <stockholm/lass/2configs/wine.nix>
    <stockholm/lass/2configs/fetchWallpaper.nix>
    <stockholm/lass/2configs/nfs-dl.nix>
    <stockholm/lass/2configs/pass.nix>
    <stockholm/lass/2configs/mail.nix>
  ];

  krebs.build.host = config.krebs.hosts.xerxes;

  environment.shellAliases = {
    deploy = pkgs.writeDash "deploy" ''
      set -eu
      export SYSTEM="$1"
      $(nix-build $HOME/sync/stockholm/lass/krops.nix --no-out-link --argstr name "$SYSTEM" -A deploy)
    '';
  };

  services.xserver = {
    displayManager.lightdm.autoLogin.enable = true;
    displayManager.lightdm.autoLogin.user = "lass";
  };

  krebs.syncthing = {
    folders = {
      the_playlist = {
        path = "/home/lass/tmp/the_playlist";
        peers = [ "mors" "phone" "prism" "xerxes" ];
      };
    };
  };
  krebs.permown = {
    "/home/lass/tmp/the_playlist" = {
      owner = "lass";
      group = "syncthing";
      umask = "0007";
    };
  };

  boot.blacklistedKernelModules = [ "xpad" ];
  systemd.services.xboxdrv = {
    wantedBy = [ "multi-user.target" ];
    script = ''
      ${pkgs.xboxdrv.overrideAttrs(o: {
        patches = [ (pkgs.fetchurl {
          url = "https://patch-diff.githubusercontent.com/raw/xboxdrv/xboxdrv/pull/251.patch";
          sha256 = "17784y20mxqrlhgvwvszh8lprxrvgmb7ah9dknmbhj5jhkjl8wq5";
        }) ];
      })}/bin/xboxdrv --type xbox360 --dbus disabled -D
    '';
  };

  programs.adb.enable = true;

  services.logind.lidSwitch = "ignore";
  services.acpid = {
    enable = true;
    lidEventCommands = ''
      export DISPLAY=:${toString config.services.xserver.display}
      case "$1" in
        "button/lid LID close")
          ${pkgs.xorg.xinput}/bin/xinput disable 'pointer:  Mouse for Windows'
          ${pkgs.xorg.xinput}/bin/xinput disable 'keyboard:  Mouse for Windows'
          ${pkgs.acpilight}/bin/xbacklight -get > /tmp/pre_lid_brightness
          ${pkgs.acpilight}/bin/xbacklight -set 0
          ;;
        "button/lid LID open")
          ${pkgs.xorg.xinput}/bin/xinput enable 'pointer:  Mouse for Windows'
          ${pkgs.xorg.xinput}/bin/xinput enable 'keyboard:  Mouse for Windows'
          ${pkgs.acpilight}/bin/xbacklight -set $(cat /tmp/pre_lid_brightness)
          ;;
      esac
    '';
  };

  systemd.services.suspend-again = {
    after = [ "suspend.target" ];
    requiredBy = [ "suspend.target" ];
    # environment = {
    #   DISPLAY = ":${toString config.services.xserver.display}";
    # };
    serviceConfig = {
      ExecStart = pkgs.writeDash "suspend-again" ''
        ${pkgs.gnugrep}/bin/grep -q closed /proc/acpi/button/lid/LID0/state
        if [ "$?" -eq 0 ]; then
          echo 'wakeup with closed lid'
          ${pkgs.systemd}/bin/systemctl suspend
        fi
      '';
      Type = "simple";
    };
  };

  hardware.bluetooth.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  # hardware.pulseaudio.configFile = pkgs.writeText "default.pa" ''
  #   load-module module-bluetooth-policy
  #   load-module module-bluetooth-discover
  #   ## module fails to load with
  #   ##   module-bluez5-device.c: Failed to get device path from module arguments
  #   ##   module.c: Failed to load module "module-bluez5-device" (argument: ""): initialization failed.
  #   # load-module module-bluez5-device
  #   # load-module module-bluez5-discover
  # '';
}
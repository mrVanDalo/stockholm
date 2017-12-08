{ config, pkgs, ... }:
with import <stockholm/lib>;
let
  user = config.krebs.build.user;
in {
  imports = [
    ./mpv.nix
    ./power-action.nix
    ./copyq.nix
    ./livestream.nix
    ./dns-stuff.nix
    ./urxvt.nix
    {
      hardware.pulseaudio = {
        enable = true;
        systemWide = true;
      };
      security.rtkit.enable = true;
      sound.enableOSSEmulation = false;
    }
    {
      krebs.per-user.lass.packages = [
        pkgs.sshuttle
      ];
      security.sudo.extraConfig = ''
        lass ALL= (root) NOPASSWD:SETENV: ${pkgs.sshuttle}/bin/.sshuttle-wrapped
      '';
    }
    { #font magic
      options.lass.fonts = {
        regular = mkOption {
          type = types.str;
          default = "-*-clean-*-*-*-*-*-*-*-*-*-*-iso10646-1";
        };
        bold = mkOption {
          type = types.str;
          default = "-*-clean-*-*-*-*-*-*-*-*-*-*-iso10646-1";
        };
        italic = mkOption {
          type = types.str;
          default = "-*-clean-*-*-*-*-*-*-*-*-*-*-iso10646-1";
        };
      };
      config.services.xresources.resources.X = ''
        *.font:       ${config.lass.fonts.regular}
        *.boldFont:   ${config.lass.fonts.bold}
        *.italicFont: ${config.lass.fonts.italic}
      '';
    }
  ];

  users.extraUsers.mainUser.extraGroups = [ "audio" "video" ];

  time.timeZone = "Europe/Berlin";

  programs.ssh.startAgent = false;
  services.openssh.forwardX11 = true;

  services.printing = {
    enable = true;
    drivers = [
      pkgs.foomatic_filters
      pkgs.gutenprint
    ];
  };

  environment.systemPackages = with pkgs; [
    acpi
    dic
    dmenu
    gi
    git-preview
    gitAndTools.qgit
    haskellPackages.hledger
    lm_sensors
    mpv-poll
    much
    ncdu
    nix-repl
    nmap
    pavucontrol
    powertop
    push
    rxvt_unicode_with-plugins
    screengrab
    slock
    sxiv
    termite
    xclip
    xorg.xbacklight
    xorg.xhost
    xsel
    youtube-tools
    yt-next
    zathura

    cabal2nix
  ];

  fonts.fonts = with pkgs; [
    hack-font
    hasklig
    symbola
    xlibs.fontschumachermisc
  ];

  lass.xserver.enable = true;
  services.xserver = {
    layout = "us";
    xkbModel = "evdev";
    xkbVariant = "altgr-intl";
    xkbOptions = "caps:backspace";
  };

  services.logind.extraConfig = ''
    HandleLidSwitch=ignore
  '';

  services.urxvtd.enable = true;
  services.xresources.enable = true;
  lass.screenlock.enable = true;
}

{ config, lib, pkgs, ... }:

with import <stockholm/lib>;
let

  ReaktorConfig = pkgs.writeText "config.py" ''
      ${if (isString cfg.overrideConfig ) then ''
      # Overriden Config
      ${cfg.overrideConfig}
      '' else ""}
      ## Extra Config
      ${concatStringsSep "\n" (map (plug: plug.config) cfg.plugins)}
      ${cfg.extraConfig}
    '';
  cfg = config.krebs.Reaktor;

  out = {
    options.krebs.Reaktor = api;
    config = lib.mkIf cfg.enable imp;
  };

  api = {
    enable = mkOption {
      default = false;
      description = ''
        Start Reaktor at system boot
      '';
    };

    nickname = mkOption {
      default = config.krebs.build.host.name + "|r";
      type = types.string;
      description = ''
        The nick name of the irc bot.
        Defaults to {hostname}|r
      '';
    };

    overrideConfig = mkOption {
      default = null;
      type = types.nullOr types.str;
      description = ''
        configuration to be used instead of default ones.
        Reaktor default cfg can be retrieved via `reaktor get-config`
      '';
    };
    plugins = mkOption {
      default = [pkgs.ReaktorPlugins.nixos-version];
    };
    extraConfig = mkOption {
      default = "";
      type = types.string;
      description = ''
        configuration appended to the default or overridden configuration
      '';
    };

    workdir = mkOption {
      default = "/var/lib/Reaktor";
      type = types.str;
      description = ''
        Reaktor working directory
      '';
    };
    extraEnviron = mkOption {
      default = {};
      type = types.attrsOf types.str;
      description = ''
        Environment to be provided to the service, can be:
          REAKTOR_HOST
          REAKTOR_PORT
          REAKTOR_STATEDIR

          debug and nickname can be set separately via the Reaktor api
      '';
    };
    channels = mkOption {
      default = [ "#krebs" ];
      type = types.listOf types.str;
      description = ''
        Channels the Reaktor should connect to at startup.
      '';
    };
    debug = mkOption {
      default = false;
      description = ''
        Reaktor debug output
      '';
    };
  };

  imp = {
    # for reaktor get-config
    users.extraUsers = singleton rec {
      name = "Reaktor";
      uid = genid name;
      description = "Reaktor user";
      home = cfg.workdir;
      createHome = true;
    };

    #users.extraGroups = singleton {
    #  name = "Reaktor";
    #  gid = config.ids.gids.Reaktor;
    #};

    systemd.services.Reaktor = {
      path = with pkgs; [
        utillinux #flock for tell_on-join
        git # for nag
        python # for caps
        ];
      description = "Reaktor IRC Bot";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        GIT_SSL_CAINFO = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
        REAKTOR_NICKNAME = cfg.nickname;
        REAKTOR_DEBUG = (if cfg.debug  then "True" else "False");
        REAKTOR_CHANNELS = lib.concatStringsSep "," cfg.channels;
        state_dir = cfg.workdir;

        } // cfg.extraEnviron;
      serviceConfig= {
        ExecStartPre = pkgs.writeScript "Reaktor-init" ''
          #! /bin/sh
          ${if (isString cfg.overrideConfig) then
            ''cp ${ReaktorConfig} /tmp/config.py''
          else
            ''(${pkgs.Reaktor}/bin/reaktor get-config;cat "${ReaktorConfig}" ) > /tmp/config.py''
          }
        '';
        ExecStart = "${pkgs.Reaktor}/bin/reaktor run /tmp/config.py";
        PrivateTmp = "true";
        User = "Reaktor";
        Restart = "always";
        RestartSec= "30" ;
        };
    };
  };

in
out

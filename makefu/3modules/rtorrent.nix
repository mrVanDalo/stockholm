{ config, lib, pkgs, ... }:

with config.krebs.lib;
let
  nginx-user = config.services.nginx.user;
  nginx-group = config.services.nginx.group;
  rutorrent-deps = with pkgs; [ curl php coreutils procps ffmpeg mediainfo ] ++
    (if config.nixpkgs.config.allowUnfree then
      trace "enabling unfree packages for rutorrent" [ unrar unzip ] else
      trace "not enabling unfree packages for rutorrent because allowUnfree is unset" [])
;
  rutorrent = pkgs.stdenv.mkDerivation {
    name = "rutorrent-src-3.7";
    src = pkgs.fetchFromGitHub {
      owner = "Novik";
      repo = "rutorrent";
      rev = "b727523a153454d4976f04b0c47336ae57cc50d5";
      sha256 = "0s5wa0jnck781amln9c2p4pc0i5mq3j5693ra151lnwhz63aii4a";
    };
    phases = [ "installPhase" ];
    installPhase = ''
      cp -r $src $out
    '';
  };
  fpm-socket = "/var/run/php5-fpm.sock";
  systemd-logfile = cfg.workDir + "/rtorrent-systemd.log";
  configFile = pkgs.writeText "rtorrent-config" ''
    # THIS FILE IS AUTOGENERATED
    ${optionalString (cfg.listenPort != null) ''
      port_range = ${toString cfg.listenPort}-${toString cfg.listenPort}
      port_random = no
    ''}

    ${optionalString (cfg.watchDir != null) ''
      schedule = watch_directory,5,5load_start=${cfg.watchDir}/*.torrent
    ''}

    directory = ${cfg.downloadDir}
    session = ${cfg.sessionDir}

    ${optionalString (cfg.xmlrpc != null) ''
      scgi_port = ${cfg.xmlrpc}
    ''}

    system.file_allocate.set = ${if cfg.preAllocate then "yes" else "no"}

    # Prepare systemd logging
    log.open_file = "rtorrent-systemd", ${systemd-logfile}
    log.add_output = "warn", "rtorrent-systemd"
    log.add_output = "notice", "rtorrent-systemd"
    log.add_output = "info", "rtorrent-systemd"
    # log.add_output = "debug", "rtorrent-systemd"
    log.execute = ${systemd-logfile}.execute
    log.xmlrpc  = ${systemd-logfile}.xmlrpc
    ${cfg.extraConfig}
  '';

  cfg = config.makefu.rtorrent;
  webcfg = config.makefu.rtorrent.web;
  out = {
    options.makefu.rtorrent = api;
    config = lib.recursiveUpdate (lib.mkIf cfg.enable imp) (lib.mkIf cfg.web.enable web-imp);
  };

  api = {
    enable = mkEnableOption "rtorrent";

    web = {
      enable = mkEnableOption "rtorrent";

      package = mkOption {
        type = types.package;
        description = ''
          path to rutorrent package
        '';
        default = rutorrent;
      };

      listenAddress = mkOption {
        type = types.str;
        description =''
          nginx listen address
        '';
        default = "localhost:8005";
      };

      webdir = mkOption {
        type = types.path;
        description = ''
          rutorrent php files will be written to this folder.
          when using nginx, be aware that the the folder should be readable by nginx.
          because rutorrent does not hold mutable data in a separate folder
          these files must be writable.
        '';
        default = "/var/lib/rutorrent";
      };
    };

    package = mkOption {
      type = types.package;
      default = pkgs.rtorrent;
    };

    xmlrpc = mkOption {
      type = with types; nullOr str;
      description = ''
        enable xmlrpc at given interface and port.

        for documentation see:
        https://github.com/rakshasa/rtorrent/wiki/RPC-Setup-XMLRPC
      '';
      example = "localhost:5000";
      default = null;
    };
    preAllocate = mkOption {
      type = types.bool;
      description = ''
        Pre-Allocate torrent files
      '';
      default = true;
    };

    logLevel = mkOption {
      type = types.str;
      description = ''
        Log level to be used for systemd log
      '';
      default = "warn";
    };

    downloadDir = mkOption {
      type = types.path;
      description = ''
        directory where torrents are stored
      '';
      default = cfg.workDir + "/downloads";
    };

    sessionDir = mkOption {
      type = types.path;
      description = ''
        directory where torrent progress is stored
      '';
      default = cfg.workDir + "/rtorrent-session";
    };

    watchDir = mkOption {
      type = with types; nullOr str;
      description = ''
        directory to watch for torrent files.
        If unset, no watch directory will be configured
      '';
      default = null;
    };

    listenPort = mkOption {
      type = with types; nullOr int;
      description =''
        listening port. if you want multiple ports, use extraConfig port_range
      '';
    };

    extraConfig = mkOption {
      type = types.string;
      description = ''
        config to be placed into ${cfg.workDir}/.rtorrent.rc

        see ${cfg.package}/share/doc/rtorrent/rtorrent.rc
      '';
      default = "";
    };

    user = mkOption {
      description = ''
        user which will run rtorrent. if kept default a new user will be created
      '';
      type = types.str;
      default = "rtorrent";
    };

    workDir = mkOption {
      description = ''
        working directory. rtorrent will search in HOME for `.rtorrent.rc`
      '';
      type = types.str;
      default = "/var/lib/rtorrent";
    };

  };

  imp = {
    systemd.services.rtorrent-daemon = {
      description = "rtorrent headless";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      restartIfChanged = true;
      serviceConfig = {
        Type = "forking";
        ExecStartPre = pkgs.writeDash "prepare-folder" ''
          mkdir -p ${cfg.workDir} ${cfg.sessionDir}
          touch ${systemd-logfile}
          cp -f ${configFile} ${cfg.workDir}/.rtorrent.rc
        '';
        ExecStart = "${pkgs.tmux.bin}/bin/tmux new-session -s rt -n rtorrent -d 'PATH=/bin:/usr/bin:${makeBinPath rutorrent-deps} ${cfg.package}/bin/rtorrent'";

        # PrivateTmp = true;
        ## now you can simply sudo -u rtorrent tmux a
        ## otherwise the tmux session is stored in some private folder in /tmp
        WorkingDirectory = cfg.workDir;
        Restart = "on-failure";
        User = "${cfg.user}";
      };

    };
    systemd.services.rtorrent-log = {
      after = [ "rtorrent-daemon.service" ];
      bindsTo = [ "rtorrent-daemon.service" ];
      wantedBy = [ "rtorrent-daemon.service" ];
      serviceConfig = {
        ExecStart = "${pkgs.coreutils}/bin/tail -f ${systemd-logfile}";
        User = "${cfg.user}";
      };
    };

    users = lib.mkIf (cfg.user == "rtorrent") {
      users.rtorrent = {
        uid = genid "rtorrent";
        home = cfg.workDir;
        group = nginx-group;
        shell = "/bin/sh"; #required for tmux
        createHome = true;
      };
      groups.rtorrent.gid = genid "rtorrent";
    };
  };
  web-imp = {
    systemd.services.rutorrent-prepare = {
      after = [ "rtorrent-daemon.service" ];
      serviceConfig = {
        Type = "oneshot";
        # we create the folder and set the permissions to allow nginx
        # TODO: update files if the version of rutorrent changed
        ExecStart = pkgs.writeDash "create-webconfig-dir" ''
          if [ ! -e ${webcfg.webdir} ];then
            echo "creating webconfiguration directory for rutorrent: ${webcfg.webdir}"
            cp -r ${webcfg.package} ${webcfg.webdir}
            chown -R ${cfg.user}:${nginx-group} ${webcfg.webdir}
            chmod -R 770 ${webcfg.webdir}
          else
            echo "not overwriting ${webcfg.webdir}"
          fi
        '';
      };
    };
    krebs.nginx.enable = true;
    krebs.nginx.servers.rutorrent = {
      listen = [ webcfg.listenAddress ];
      extraConfig = "root ${webcfg.webdir};";
      # TODO: authentication
      locations = [
        # auth_basic "Restricted";        ##auth zone - whatever you want to use
        # auth_basic_user_file torpasswd; ##auth file - relative to /etc/nginx/.

        (nameValuePair "/RPC2" ''
          scgi_pass localhost:5000;
          include ${pkgs.nginx}/conf/scgi_params;
        '')
        (nameValuePair "~ \.php$" ''
          root ${webcfg.webdir};
          client_max_body_size 200M;
          fastcgi_split_path_info ^(.+\.php)(/.+)$;
          fastcgi_pass unix:${fpm-socket};
          try_files $uri =404;
          fastcgi_index  index.php;
          include ${pkgs.nginx}/conf/fastcgi_params;
          include ${pkgs.nginx}/conf/fastcgi.conf;
        '')

      ];
    };
    services.phpfpm = {
      # phpfpm does not have an enable option
      poolConfigs  = let
        user = config.services.nginx.user;
        group = config.services.nginx.group;
        fpm-socket = "/var/run/php5-fpm.sock";
      in {
        rutorrent = ''
          user =  ${user}
          group =  ${group}
          listen = ${fpm-socket}
          listen.owner = ${user}
          listen.group = ${group}
          pm = dynamic
          pm.max_children = 5
          pm.start_servers = 2
          pm.min_spare_servers = 1
          pm.max_spare_servers = 3
          chdir = /
          # errors to journal
          php_admin_value[error_log] = 'stderr'
          php_admin_flag[log_errors] = on
          catch_workers_output = yes
          env[PATH] = ${makeBinPath rutorrent-deps}
        '';
      };
    };
  };
in
out


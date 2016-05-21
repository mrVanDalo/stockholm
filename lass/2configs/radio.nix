{ config, pkgs, ... }:
let
  name = "radio";
  mainUser = config.users.extraUsers.mainUser;
  inherit (config.krebs.lib) genid;

  admin-password = import <secrets/icecast-admin-pw>;
  source-password = import <secrets/icecast-source-pw>;

in {
  users.users = {
    "${name}" = rec {
      inherit name;
      group = name;
      uid = genid name;
      description = "radio manager";
      home = "/home/${name}";
      useDefaultShell = true;
      createHome = true;
      openssh.authorizedKeys.keys = [
        config.krebs.users.lass.pubkey
      ];
    };
  };

  users.groups = {
    "radio" = {};
  };

  krebs.per-user.${name}.packages = with pkgs; [
    ncmpcpp
    mpc_cli
    tmux
  ];

  security.sudo.extraConfig = ''
    ${mainUser.name} ALL=(${name}) NOPASSWD: ALL
  '';

  services.mpd = {
    enable = true;
    group = "radio";
    musicDirectory = "/home/radio/the_playlist/music";
    extraConfig = ''
      audio_output {
          type        "shout"
          encoding    "ogg"
          name        "my cool stream"
          host        "localhost"
          port        "8000"
          mount       "/radio.ogg"

      # This is the source password in icecast.xml
          password    "${source-password}"

      # Set either quality or bit rate
      #   quality     "5.0"
          bitrate     "128"

          format      "44100:16:1"

      # Optional Parameters
          user        "source"
      #   description "here is my long description"
      #   genre       "jazz"
      } # end of audio_output

    '';
  };

  services.icecast = {
    enable = true;
    hostname =  "config.krebs.build.host.name";
    admin.password = admin-password;
    extraConf = ''
      <authentication>
        <source-password>${source-password}</source-password>
      </authentication>
    '';
  };

  krebs.iptables = {
    tables = {
      filter.INPUT.rules = [
        { predicate = "-p tcp --dport 8000"; target = "ACCEPT"; }
      ];
    };
  };

  systemd.timers.radio = {
    description = "radio autoadder timer";
    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnCalendar = "*:*";
    };
  };

  systemd.services.radio = let
    autoAdd = pkgs.writeDash "autoAdd" ''
      LIMIT=$1 #in secconds

      addRandom () {
        mpc add "$(mpc ls | shuf -n1)"
      }

      timeLeft () {
        playlistDuration=$(mpc --format '%time%' playlist | awk -F ':' 'BEGIN{t=0} {t+=$1*60+$2} END{print t}')
        currentTime=$(mpc status | awk '/^\[playing\]/ { sub(/\/.+/,"",$3); split($3,a,/:/); print a[1]*60+a[2] }')
        expr ''${playlistDuration:-0} - ''${currentTime:-0}
      }

      if test $(timeLeft) -le $LIMIT; then
        addRandom
      fi
    '';
  in {
    description = "radio playlist autoadder";
    after = [ "network.target" ];

    path = with pkgs; [
      gawk
      mpc_cli
    ];

    restartIfChanged = true;

    serviceConfig = {
      Restart = "always";
      ExecStart = "${autoAdd} 100";
    };
  };
}

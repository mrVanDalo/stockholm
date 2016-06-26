{ config, lib, pkgs, ... }:

with config.krebs.lib;

let
  mirror = "git@${config.networking.hostName}:";

  defineRepo = name: announce: let
    repo = {
      public = true;
      name = mkDefault "${name}";
      cgit.desc = mkDefault "mirror for all ${name} branches";
      hooks = mkIf announce (mkDefault {
        post-receive = pkgs.git-hooks.irc-announce {
          nick = config.networking.hostName;
          verbose = false;
          channel = "#retiolum";
          server = "cd.retiolum";
        };
      });
    };
  in {
    rules = with git; singleton {
      user = [ config.krebs.users."${config.networking.hostName}-repo-sync" ];
      repo = [ repo ];
      perm = push ''refs/*'' [ non-fast-forward create delete merge ];
    };
    repos."${name}" = repo;
  };

  sync-retiolum = name:
    {
      krebs.repo-sync.repos.${name} = {
        makefu = {
          origin.url = "http://cgit.gum/${name}";
          mirror.url = "${mirror}${name}";
        };
        tv = {
          origin.url = "http://cgit.cd/${name}";
          mirror.url = "${mirror}${name}";
        };
        lassulus = {
          origin.url = "http://cgit.prism/${name}";
          mirror.url = "${mirror}${name}";
        };
        "@latest" = {
          mirror.url = "${mirror}${name}";
          mirror.ref = "heads/newest";
        };
      };
      krebs.git = defineRepo name (config.networking.hostName == "prism");
    };

  sync-remote = name: url:
    {
      krebs.repo-sync.repos.${name} = {
        remote = {
          origin.url = url;
          mirror.url = "${mirror}${name}";
        };
      };
      krebs.git = defineRepo name (config.networking.hostName == "prism");
    };

  sync-remote-silent = name: url:
    {
      krebs.repo-sync.repos.${name} = {
        remote = {
          origin.url = url;
          mirror.url = "${mirror}${name}";
        };
      };
      krebs.git = defineRepo name false;
    };

in {
  krebs.repo-sync = {
    enable = true;
    unitConfig.ConditionPathExists = "!/var/run/ppp0.pid";
  };
  imports = [
    (sync-remote "array" "https://github.com/makefu/array")
    (sync-remote "email-header" "https://github.com/4z3/email-header")
    (sync-remote "mycube-flask" "https://github.com/makefu/mycube-flask")
    (sync-remote "reaktor-titlebot" "https://github.com/makefu/reaktor-titlebot")
    (sync-remote "repo-sync" "https://github.com/makefu/repo-sync")
    (sync-remote "skytraq-datalogger" "https://github.com/makefu/skytraq-datalogger")
    (sync-remote "xintmap" "https://github.com/4z3/xintmap")
    (sync-remote-silent "nixpkgs" "https://github.com/nixos/nixpkgs")
    (sync-retiolum "go")
    (sync-retiolum "much")
    (sync-retiolum "newsbot-js")
    (sync-retiolum "painload")
    (sync-retiolum "realwallpaper")
    (sync-retiolum "stockholm")
    (sync-retiolum "wai-middleware-time")
    (sync-retiolum "web-routes-wai-custom")
    (sync-retiolum "xmonad-stockholm")
  ];
}


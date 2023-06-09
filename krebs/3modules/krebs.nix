{ config, lib, ... }:
with lib;
let
  cfg = config.krebs;

  out = {
    options.krebs = api;
    config = lib.mkIf cfg.enable imp;
  };

  api = {
    enable = mkEnableOption "krebs";

    zone-head-config  = mkOption {
      type = with types; attrsOf str;
      description = ''
        The zone configuration head which is being used to create the
        zone files. The string for each key is pre-pended to the zone file.
      '';
      # TODO: configure the default somewhere else,
      # maybe use krebs.dns.providers
      default = {

        # github.io -> 192.30.252.154
        "krebsco.de" = ''
          $TTL 86400
          @ IN SOA dns19.ovh.net. tech.ovh.net. (2015052000 86400 3600 3600000 86400)
                                IN NS     ns19.ovh.net.
                                IN NS     dns19.ovh.net.
        '';
      };
    };
  };

  imp = lib.mkMerge [
    {
      services.openssh.hostKeys =
        let inherit (config.krebs.build.host.ssh) privkey; in
        mkIf (privkey != null) [privkey];

      services.openssh.knownHosts =
        filterAttrs
          (knownHostName: knownHost:
            knownHost.publicKey != null &&
            knownHost.hostNames != []
          )
          (mapAttrs
            (hostName: host: {
              hostNames =
                concatLists
                  (mapAttrsToList
                    (netName: net:
                      let
                        aliases =
                          concatLists [
                            shortAliases
                            net.aliases
                            net.addrs
                          ];
                        shortAliases =
                          optionals
                            (cfg.dns.search-domain != null)
                            (map (removeSuffix ".${cfg.dns.search-domain}")
                                 (filter (hasSuffix ".${cfg.dns.search-domain}")
                                         net.aliases));
                        addPort = alias:
                          if net.ssh.port != 22
                            then "[${alias}]:${toString net.ssh.port}"
                            else alias;
                      in
                      map addPort aliases
                    )
                    host.nets);
              publicKey = host.ssh.pubkey;
            })
            (foldl' mergeAttrs {} [
              cfg.hosts
              {
                localhost = {
                  nets.local = {
                    addrs = [ "127.0.0.1" "::1" ];
                    aliases = [ "localhost" ];
                    ssh.port = 22;
                  };
                  ssh.pubkey = config.krebs.build.host.ssh.pubkey;
                };
              }
            ]));

      programs.ssh.extraConfig = concatMapStrings
        (net: ''
          Host ${toString (net.aliases ++ net.addrs)}
            Port ${toString net.ssh.port}
        '')
        (filter
          (net: net.ssh.port != 22)
          (concatMap (host: attrValues host.nets)
            (mapAttrsToList
              (_: host: recursiveUpdate host
                (optionalAttrs (cfg.dns.search-domain != null &&
                                hasAttr cfg.dns.search-domain host.nets) {
                  nets."" = host.nets.${cfg.dns.search-domain} // {
                    aliases = [host.name];
                    addrs = [];
                  };
                }))
              config.krebs.hosts)));
    }
  ];

in out

with import <stockholm/lib>;
{ config, ... }:
let
  hostDefaults = hostName: host: flip recursiveUpdate host ({
    ci = false;
    external = true;
    monitoring = false;
    owner = config.krebs.users.rtunreal;
  } // optionalAttrs (host.nets?retiolum) {
    nets.retiolum = {
      ip6.addr = (krebs.genipv6 "retiolum" "external" { inherit hostName; }).address;
    };
  } // optionalAttrs (host.nets?wiregrill) {
    nets.wiregrill = {
      ip6.addr = (krebs.genipv6 "wiregrill" "external" { inherit hostName; }).address;
    };
  });
in
{
  users = rec {
    rtunreal = {
      # Mail is temporary as it will change in the future and I
      # don't want it to be semi permanent
      # mail: krebscotemp(a)user-sites[point]de
    };
  };
  hosts = mapAttrs hostDefaults {
    rtspinner = {
      nets.retiolum = {
        aliases = [ "spinner.rtunreal.r" ];
        ip4.addr = "10.243.20.18";
        tinc.pubkey = ''
          -----BEGIN RSA PUBLIC KEY-----
          MIICCgKCAgEApgnFW2hCP2Lf+CGMtzgiTyA9sphEKGzVtOTJy+LxZ/WchFU6QiU6
          Dl5ybz/Bor25dbwvQCRsQo42gPb+xyjsoHGu2q1NVazMQobePjt/8Qzfqw+Ydz3e
          CC0Lq2J7A5HkzHAevvSHjWh52EfAfu9PGnsszDyWY/oKY+JkBd3wdnE4VsZIhUU6
          Zrmuq+JU53Wy4TAcd3JNStvTW3z7MK4BXxovTV3zSq9sg4a120dyrG/d/m35abvm
          V20Qb9VPmG+861f7gBn45M1w9d4X+3Ev8zum60Lk9JDRETfnufbOsSWNFVk2nsc3
          wpCYd+7FMq5hBf75At/pQ32kbsMkAMpQDJlHwE/xmhxYU2mzlMLY6JW1gspOt00C
          iny5qqmhMoZ3r1VmGuu1aA00V+My+dj5i+pvZiUQ9DG2eYoKM43Var2XsU6lURpL
          UhozcYkb+ax9mqlaPjq2BSYLNzmqTJc3FJY6CcyZxIi4aB8EhDeebYD7wIX115tf
          wwMIJB9FgmvwBhL2K48P5p8lmxU0sNidvv/Gnr3Fgf1p+jEo8BC9hDK3gigD0lqo
          AGmRrjHQN7AjysTMTllDj8RSoO2LhOYTxVtcMsQnPJ9hfFrgnSpSZok64y0h+QJG
          q2WZRBwRYORC7JfKNbE6drRtM6DXccMxOM0eQXoDvg3D5Xg4aqWy3ikCAwEAAQ==
          -----END RSA PUBLIC KEY-----
        '';
        tinc.pubkey_ed25519 = "eHWJxlhbUQY0rT2PLqbqb9W4hf7zHh3+gEIRaGrxAdB";
      };
    };
  };
}
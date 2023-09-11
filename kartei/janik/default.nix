{ config, lib, ... }: let
  slib = import ../../lib/pure.nix { inherit lib; };
  hostDefaults = hostName: host: lib.flip lib.recursiveUpdate host ({
    ci = false;
    external = true;
    monitoring = false;
  } // lib.optionalAttrs (host.nets?retiolum) {
    nets.retiolum.ip6.addr =
      (slib.krebs.genipv6 "retiolum" "external" { inherit hostName; }).address;
  });
in {
  users.janik = {
    mail = "retiolum.janik@aq0.de";
  };
  hosts.hertz = {
    owner = config.krebs.users.janik;
    nets.retiolum = {
      aliases = [ "hertz.janik.r" ];
      ip6.addr = (slib.krebs.genipv6 "retiolum" "janik" { hostName = "hertz"; }).address;
      tinc.pubkey = ''
        -----BEGIN RSA PUBLIC KEY-----
        MIICCgKCAgEA0mqxrdVU9wFhNZYGWEknJpKV4yIodNlaCIKDPVhU5wmlzh2szKUS
        V3PzyEAo4DaQCZXdpj1jS9ddN+yLj68K4k4LRLuCyXep0GcFM1mUKQTBOxa3VF+W
        oRaSUAVHib/jUiX08BIxYBDwiCUPSdEBUHWftnc8WYvjthPkOOuGAvs1w9ZBs6qC
        ftkVJT5rt8cU9VsXPqRRauVHb9wH1M41p5/3HtBAgVBtCDp/qXmABW0rbXEKtwmv
        +hzZoMvxTm05cAE7O2UlluERdnheKkBXWuBYR4aC9BQQH54kIShByOZYYACWuGGA
        oHHqITYwWh+42wacAKCkTZ6kHoIQrU+uDypQ24YBhxbqUiGTspGbfO/jDHxxjgrd
        Aauxil2YNQNclEZuWFD4Hlt2Y29jDh7uQwBbOl3dmTLvXr8qTA5HQIsf9uuOrvu9
        uejj8VMIUHxdSZi8oH3+4XOH43DAGWM2pZogE+jeZtc2hPjqz1XZ40tXBPfEeUr4
        VE4l1q4m9ynEMZbMZjyDGxX4Yo9htgJmKGk3LQ0ufbOo5CQM/lqzAZVYDKBlW7ka
        rTgh9ZwMmd3/5ije3nI94Bd+2x+TLJ8ESCloqLYGZ0HaIRU1b5JX5a44+OPq5obB
        sClD3CzaqMDkoEDBWrEyst8VkqZUWKmicnWtZapNWW67mjXBtzUQmOUCAwEAAQ==
        -----END RSA PUBLIC KEY-----
      '';
      tinc.pubkey_ed25519 = "iT84cW45GuGqsEGgtVwGwe36iGFAha/orKcyZp8VbxH";
    };
  };
}

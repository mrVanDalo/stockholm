{ config, ... }:

{
  tv.consul = rec {
    enable = true;

    self = config.krebs.build.host;
    inherit (self) dc;

    server = true;

    hosts = with config.krebs.hosts; [
      # TODO get this list automatically from each host where tv.consul.enable is true
      cd
      mkdir
      nomic
      rmdir
      #wu
    ];
  };
}

{ config, lib, ... }:
{
  imports = [
    ../../kartei
    ./acl.nix
    ./airdcpp.nix
    ./announce-activation.nix
    ./apt-cacher-ng.nix
    ./backup.nix
    ./bepasty-server.nix
    ./bindfs.nix
    ./brockman.nix
    ./build.nix
    ./cachecache.nix
    ./ci
    ./current.nix
    ./dns.nix
    ./exim-retiolum.nix
    ./exim-smarthost.nix
    ./exim.nix
    ./fetchWallpaper.nix
    ./git.nix
    ./github
    ./go.nix
    ./hidden-ssh.nix
    ./hosts.nix
    ./htgen.nix
    ./iana-etc.nix
    ./iptables.nix
    ./kapacitor.nix
    ./konsens.nix
    ./krebs.nix
    ./krebs-pages.nix
    ./monit.nix
    ./nixpkgs.nix
    ./on-failure.nix
    ./os-release.nix
    ./per-user.nix
    ./permown.nix
    ./power-action.nix
    ./reaktor2.nix
    ./realwallpaper.nix
    ./repo-sync.nix
    ./retiolum-bootstrap.nix
    ./secret.nix
    ./setuid.nix
    ./shadow.nix
    ./sitemap.nix
    ./ssl.nix
    ./sync-containers.nix
    ./sync-containers3.nix
    ./systemd.nix
    ./tinc.nix
    ./tinc_graphs.nix
    ./upstream
    ./urlwatch.nix
    ./users.nix
    ./xresources.nix
    ./zones.nix
  ];
}

{ config, pkgs, ... }:

{
  imports = [
    <stockholm/lass>

    <stockholm/lass/2configs/mouse.nix>
    <stockholm/lass/2configs/retiolum.nix>
    <stockholm/lass/2configs/git.nix>
    <stockholm/lass/2configs/exim-retiolum.nix>
    <stockholm/lass/2configs/baseX.nix>
    <stockholm/lass/2configs/browsers.nix>
    <stockholm/lass/2configs/programs.nix>
    <stockholm/lass/2configs/fetchWallpaper.nix>
    <stockholm/lass/2configs/games.nix>
    <stockholm/lass/2configs/bitcoin.nix>
    <stockholm/lass/2configs/backup.nix>
    <stockholm/lass/2configs/wine.nix>
    <stockholm/lass/2configs/blue-host.nix>
  ];

  krebs.build.host = config.krebs.hosts.icarus;

  environment.systemPackages = with pkgs; [
    macchanger
    dpass
  ];
  services.redshift = {
    enable = true;
    provider = "geoclue2";
  };
  programs.adb.enable = true;
}

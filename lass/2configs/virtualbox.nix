{ config, pkgs, ... }:

let
  mainUser = config.users.extraUsers.mainUser;

in {
  virtualisation.virtualbox.host.enable = true;

  users.extraUsers = {
    virtual = {
      name = "virtual";
      description = "user for running VirtualBox";
      home = "/home/virtual";
      useDefaultShell = true;
      extraGroups = [ "vboxusers" "audio" ];
      createHome = true;
    };
  };
  security.sudo.extraConfig = ''
    ${mainUser.name} ALL=(virtual) NOPASSWD: ALL
  '';
}

{ config, lib, ... }: let
  slib = import ../../lib/pure.nix { inherit lib; };
in {
  users.berber = {
    mail = "berber@zmberber.com";
  };
  hosts.schlepptop = {
    owner = config.krebs.users.berber;
    nets.retiolum = {
      aliases = [ "schlepptop.berber.r" ];
      ip6.addr = (slib.krebs.genipv6 "retiolum" "berber" { hostName = "schlepptop"; }).address;
      tinc.pubkey = ''
-----BEGIN RSA PUBLIC KEY-----
MIICCgKCAgEAsotvQWb0zgZzHQheM2LBMCyxYZ4JqWcpLkfz8nvLJl6wktEWz8IH
7hkc9qjrvR0jLecO79PzFaF9n6h47OBMhJC2BzJJJys0iiOUcjWpMtLGUZTy2M83
Wtfz8YuY0zMJmnt63cVFpEsorj2v99YmYxQww8IU1iSpxotNx1hED/3dEN44qqlL
/aYRrnuFb/UOMxTcanpezJRqgqQpXBmlXYM0uE/uqUOWxHpWtQB5DsMf3s3YET/j
N7yp8DStlAqRruWS52GtWqnqXTgRBjqcIdGvmSRP0ZsHEEXk7du7icAlo1ZdGDQ1
BXo1LTeiKr7Ujb7f5Kz/aq0+xZsODXVjYwiS5ZuZvHO+YD0/eDD4YwQyCovJDNRS
1GEkOBcE3acVn55ygg27PiRdm4FLbPoEL8t6CpgUCFVt1LTuuu/h++8WrbR4ggVp
A8/5xmcUPd0DtWk9Uj++3ZW1PmPLnMtTFuUSkzLv1rdfCHgtQbTcTSEXByaizKlp
CZdCSZjQnycBhPRW56ySWX3du38MNeAAlwGfXUjt4lOQsFiPs55MAedN9/JoTQCp
2uJ+oy2I2zPWxt03e/3WW8eD0csTiSA4c/KRCtHKr9DCaT83Lmal52ztwmxzXhzU
Aa8Zk+rzxj+e48Lab8COzOuqUyWYruxsFoM4BumEfmNOBrkXKCPjVokCAwEAAQ==
-----END RSA PUBLIC KEY-----
      '';
      tinc.pubkey_ed25519 = "soXXSBhFM1/V7otecSzUIwTT4Zpn4DLyJ5B5p7Euz/B";
    };
  };
}

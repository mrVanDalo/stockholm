{ config, lib, ... }:
let
  inherit (lib) flip mapAttrs optionalAttrs recursiveUpdate;
  slib = import ../../lib/pure.nix { inherit lib; };
  maybeEmpty = attrset: key: if (attrset?key) then attrset.${key} else [];
  hostDefaults = hostName: host: flip recursiveUpdate host ({
    ci = false;
    external = true;
    monitoring = false;
    owner = config.krebs.users.kmein;
  } // optionalAttrs (host.nets?retiolum) {
    nets.retiolum = {
      ip6.addr = (slib.krebs.genipv6 "retiolum" "external" { inherit hostName; }).address;
    };
  } // optionalAttrs (host.nets?wiregrill) {
    nets.wiregrill = {
      ip6.addr = (slib.krebs.genipv6 "wiregrill" "external" { inherit hostName; }).address;
    };
  });
  ssh-for = name: builtins.readFile (./ssh + "/${name}.pub");
in
{
  users = rec {
    kmein = kmein-kabsa;
    kmein-kabsa = {
      mail = "kmein@posteo.de";
      pubkey = ssh-for "kmein.kabsa";
    };
    kmein-manakish = {
      inherit (kmein-kabsa) mail;
      pubkey = ssh-for "kmein.manakish";
    };
  };
  hosts = mapAttrs hostDefaults {
    ful = {
      nets.retiolum = {
        aliases = [ "ful.r" ];
        ip4.addr = "10.243.2.107";
        tinc.pubkey = ''
          -----BEGIN RSA PUBLIC KEY-----
          MIICCgKCAgEAwoaPWvnl+g9KYh8coXj/RAaxGHEtbuTG2NpWxbeJG0CemxBoYz2c
          EE/2JbGRrSaNj3nrFWBTqmTuEB7nHyurFe06G0t+Or5eCBPg2zS5LiQE/LTZV08t
          5jUm0jfOQHWbtCMrFGisH9R9Z3XId5cJGN1KsYg4R9RkKIKVVhKJ7maBWbsc+V5G
          LxKEdDL7T4AfesQzzlAYUQ/s+zHlwJ2fyl3NrBg6Nc27C2A2g9pefhJbn0h8lWdn
          I627DIrjDMvoSTiF1MKD/N4bXbF665gflUxbI5DTTHCtWf+0lP9i8mXP0kXQU4By
          2QLdcpQzlHgnprI+qio1ioKuojcPcryYaOnpQWFHL6AqHzkRJRpMLPBhgQPbpz1v
          BaShxGBasSHO+Htw5PbwrNwWvU8eH5joRQu3PBgzATS9M91RN58i03u2oQMt3Qif
          e5USnfk3iYir/qkJWJk8m2kveZy0giI8AaRISu0jXNsB8euQXP2dxTKIF3BPEi5m
          MZKTGTS4Tz3alpHWaeJtfJT0ihq4HME91rTKgP+CIHWYR4hmTPyYgrX0mm2MN+wi
          G4vJXtcmBaCdcQZ1buCBVWJCUJ0bWZ3Fs4Ohjw6bP3iyb+Q5UOcXNyOi5NpaUbAi
          47F5O6hvEWPxHRhvPD/9NASjRSxaUDbBVj5lieUXCHnhMSAHo1H3kHMCAwEAAQ==
          -----END RSA PUBLIC KEY-----
        '';
        tinc.pubkey_ed25519 = "id5vF2fBwUCMrT5HLvIpeXmvQMQoksUBYXOdc9RyOUF";
      };
    };
    kabsa = {
      nets.retiolum = {
        aliases = [ "kabsa.r" "kabsa.kmein.r" ];
        ip4.addr = "10.243.2.4";
        tinc.pubkey = ''
          -----BEGIN PUBLIC KEY-----
          MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAtz/MY5OSxJqrEMv6Iwjk
          g/V58MATljj+2bmOuOuPui/AUYHEZX759lHW4MgLjYdNbZEoVq8UgkxNk0KPGlSg
          2lsJ7FneCU7jBSE2iLT1aHuNFFa56KzSThFUl6Nj6Vyg5ghSmDF2tikurtG2q+Ay
          uxf5/yEhFUPc1ZxmvJDqVHMeW5RZkuKXH00C7yN+gdcPuuFEFq+OtHNkBVmaxu7L
          a8Q6b/QbrwQJAR9FAcm5WSQIj2brv50qnD8pZrU4loVu8dseQIicWkRowC0bzjAo
          IHZTbF/S+CK0u0/q395sWRQJISkD+WAZKz5qOGHc4djJHBR3PWgHWBnRdkYqlQYM
          C9zA/n4I+Y2BEfTWtgkD2g0dDssNGP5dlgFScGmRclR9pJ/7dsIbIeo9C72c6q3q
          sg0EIWggQ8xyWrUTXIMoDXt37htlTSnTgjGsuwRzjotAEMJmgynWRf3br3yYChrq
          10Exq8Lej+iOuKbdAXlwjKEk0qwN7JWft3OzVc2DMtKf7rcZQkBoLfWKzaCTQ4xo
          1Y7d4OlcjbgrkLwHltTaShyosm8kbttdeinyBG1xqQcK11pMO43GFj8om+uKrz57
          lQUVipu6H3WIVGnvLmr0e9MQfThpC1em/7Aq2exn1JNUHhCdEho/mK2x/doiiI+0
          QAD64zPmuo9wsHnSMR2oKs0CAwEAAQ==
          -----END PUBLIC KEY-----
        '';
        tinc.pubkey_ed25519 = "KhOetVTVLtGxB22NmZhkTWC0Uhg8rXJv4ayZqchSgCN";
      };
    };
    makanek = {
      nets.retiolum = {
        aliases = [
          "makanek.r"
          "makanek.kmein.r"
          "grafana.kmein.r"
          "alertmanager.kmein.r"
          "prometheus.kmein.r"
          "names.kmein.r"
          "graph.r"
          "rrm.r"
          "redaktion.r"
        ];
        ip4.addr = "10.243.2.84";
        tinc.pubkey = ''
          -----BEGIN RSA PUBLIC KEY-----
          MIICCgKCAgEAwvtxCG7Vua6+WoStGrkL+H/g4BABidL2eikDBtbxWN+oGv2Bjrwb
          VzXB8lMTCsu6M2wb3YTXXzAkc5oI4gE1sSOiCKyhYnQRrndc91KewquxTPfKL19u
          JiRqax/E49IvWKARPRPXUhPfU/NNw1oIxhbcFkjwJmqDvh9SWhl5VZVynCE28ov5
          hjjhqNXZHOR8CQqPJeY8v38OAAwTWvJ6rhEQwp5dLBqmRAbvPXj7OOzCxKluDY2X
          Dl4k6QAjI6NddJXsXHRYRNGiB0CP1UBC91NDtW2+HIjf1Q1Lip5agO4/SkkSUt39
          de7uYKrNcfyDUBb9Suconw0HvW+Dv4Ce5um+aa1RUrWIQdqBCOECbsXYKp66vAnK
          Hidf2uznFseWxiyxz1ow8AvvSseABej5GuHI/56lywnFlnHEZLREUF/4PT+BZ0vE
          uPRkzqeSNybsYYFieK8aany/RmJaoIsduGutgAiKBvkCCHru895n02xuLhZVkM2G
          zfVjA2le+Gxr21/sVPrHfxResLUh4RA8fkS7erWMRF4a3IOpIS4yrM+p4pZTlTxO
          Ya8buh4RgyE/0hp4QNpa4K7fvntriK+k6zHs7BcZcG2aMWP3O9/4DgjzBR3eslQV
          oou23ajP11wyfrmZK0/PQGTpsU472Jj+06KtMAaH0zo4vAR8s2kV1ukCAwEAAQ==
          -----END RSA PUBLIC KEY-----
        '';
        tinc.pubkey_ed25519 = "GiAe9EH3ss+K71lRlkGaOcg/MrV/zxNW5tDF0koEGvC";
      };
    };
    manakish = {
      nets.retiolum = {
        aliases = [
          "manakish.r"
          "manakish.kmein.r"
        ];
        ip4.addr = "10.243.2.85";
        tinc.pubkey = ''
          -----BEGIN RSA PUBLIC KEY-----
          MIICCgKCAgEAtZcWwm1tTFoMcO0EOwNdSrZW9m2tSNWzwTGjlfuNFQKPnHiKdFFH
          Hym72+WtaIZmffermGTfYdMoB/lWgOB0glqH9oSBFvrLVDgdQL2il589EXBd/1Qy
          7Ye5EVy2/xEA7iZGg3j0i+q1ic48tt6ePd4+QR0LmLEa8+Gz5X0Tp9TTf7gdv+lB
          dVA6p7LJixKcBsC5W0jY5oTGUP0fM844AtWbpflmlz0JZNWrkJhCksOnfhUzeIsF
          1m9rCsyK+3jGMV6ZxhEbwaOt99Wlv0N0ouPePw+xLnnGTu0rJ/RKWceYnWnrHIyb
          GgGIHnm9GbMd4mAfyp63emRYDMclSQSrddpDUL2GK8TCTttr6bZm4M/pFuXQGJsQ
          EG0iaE8FM+nCrhmCRnX8dRWcNmHybd34UoVGCDJ6u+ksLIivqgWeY41CauqN0vQw
          U4zqp6XMXRB6vlVcyLzdTASxVKaLJt+BuvHcyqz/YslJ97z4yoLE3d7s/9gZkM//
          +FD970bsyvKpKRx72rNRCO9tQJNgPsaMiW5nuHUFw71XxX8o0w//5a0h5cdbiT64
          I4ISySa4ynmHI1/v0a937/sFS0IvRI1Va0Efh2VxasNIqpDmM3hA8auPDj0Js/4c
          qVnWMbvqqYlY9l//HCNxUXIhi0vcOr2PoCxBtcP5pHY8nNphQrPjRrcCAwEAAQ==
          -----END RSA PUBLIC KEY-----
        '';
        tinc.pubkey_ed25519 = "CjSqXJMvJevjqX9W9sqDpLTJs9DXfC04YNAFpYqS2iN";
      };
    };
    g7power = {
      nets.wiregrill = {
        ip4.addr = "10.244.2.97";
        aliases = [ "phone.kmein.w" ];
        wireguard.pubkey = "09yVPHL/ucvqc6V5n7vFQ2Oi1LBMdwQZDL+7jBwy+iQ=";
      };
    };
    tabula = {
      nets.retiolum = {
        ip4.addr = "10.243.2.78";
        aliases = [ "tabula.r" "tabula.kmein.r" ];
        tinc.pubkey = ''
          -----BEGIN RSA PUBLIC KEY-----
          MIICCgKCAgEA4cdFDoKRA9t+r686w6gH1u4UjEQJBmhsf3tkPEkv7nyVr4ahcZQk
          rQwlhNRJwv0wekwO0qG19VoAmBkVMzYu5JWn9WeYfIEUtP3ndPa7tqWQ4qIkYh8q
          4KQ03Y3CZav5ClK9rLO7gj+dsP+BhVdqhte4pJANs4CyglYkyu6p0P4+R2P0tfcq
          LTl8RB+SXuafqzhoQD+yhhA1HR8O1o9gHJjKiEVrSLwSFfD8WWH55yeWzIYAbuv8
          8a5VzhS5zvDYUFTP1WUPTeGlKsJdslSZqsrZmBDpkh1iEpRzQUnwQNMJ/uGXIldE
          3FKKoL9LKlvr1Iz9IcuxO4QLk+DoC8+Jc7yQrwIiQQCwAfwdyY6KcRDAqna1WZRd
          MFRvPd6y1BmLVJMG43VpWm5POE9Gw5nj5IzSNAFshoNljf246y2+wf8EtULqtrJD
          DMckquiYRnzQPco9PgjLfH/6SnlB/oXhvT4+rB4KceSoFKOLWq1pFogDGDy0xyB0
          ufkPsXiYE2KRnkozDJWlKSqrkM3GSR2lTM5cAmLh8VzxkI6LeJu8/6qxFa6J6tn4
          +kH8yjbcLqjmuUykfOZ2eL4GniaFexDvZcGgLD1I5f1ylEmSuU6boyx83WkCH7NH
          1cmaBDQsy4x0gMUYlLDVDW7X2PECoq5mQ61FHBNkdNOujOM/JPnYf4UCAwEAAQ==
          -----END RSA PUBLIC KEY-----
        '';
        tinc.pubkey_ed25519 = "eZsnMScJdH5k/W3Y5fILnz5Kc01R+dRzjjE/cnu96VF";
      };
    };
    tahina = {
      nets.retiolum = {
        ip4.addr = "10.243.2.74";
        aliases = [ "tahina.r" "tahina.kmein.r" ];
        tinc.pubkey = ''
          -----BEGIN RSA PUBLIC KEY-----
          MIICCgKCAgEAtX6RpdFl9AqCF6Jy9ZhGY1bOUnEw5x3wm8gBK/aFb5592G3sGbWV
          5Vv1msdLcoYQ5X4sgp3wizE5tbW7SiRVBwVB4mfYxe5KSiFJvTmXdp/VtKXs/hD8
          VXNBjCdPeFOZ4Auh4AT+eibA/lW5veOnBkrsD/GkEcAkKb2MMEoxv4VqLDKuNzPv
          EfE+mIb/J3vJmfpLG/+VGLrCuyShjPR2z0o5KMg8fI4ukcg6vwWwGE3Qd8JkSYMz
          iy9oIGo/AJNyOUG0vQXL1JU/LFBXKty515UmXR2hO/Xi1w92DT8lxfLYRgoseT2u
          i4aHmfl49LGkpQVIFejj6R0FrZBd5R2ElmQbmxSKS1PO9VheOOm02fgVXRpeoh6R
          FdDkFWWmELW921UtEB2jSIMkf5xW8XmlJlGveaDnkld07aQlshnnOUfIs3r7H+T9
          9g1QxiE7EFeoLrfIkgT81F+iL6RazSbf9DcTxvrKv+cZBrZKdcurcTtX0wFFD4wZ
          0tzYPTcAnv/ytacf2/jv/Vm3xNFyjrBLM6ZtJtZ6NAJvD+OW4G/o2941KCu1Mqz/
          VFAJW3djrqfASNCU1GqtHV0wdJMN8EszDNYdJ7pyw6+rG2PeYCVfE7wNe3b6zYqY
          tUYhU1xkQQD4xgOMX3AdSI/JGjxMBBKlJXafwdDW8LMBWBPt+9Xq2vMCAwEAAQ==
          -----END RSA PUBLIC KEY-----
        '';
        tinc.pubkey_ed25519 = "m8fnOzCx2KVsQx/616+AzVW5OTgAjBGDoT/PpKuyx+I";
      };
    };
    zaatar = {
      nets.retiolum = {
        ip4.addr = "10.243.2.34";
        aliases = [
          "zaatar.r"
          "zaatar.kmein.r"
          "grocy.kmein.r"
          "moodle.kmein.r"
          "radio.kmein.r"
          "home.kmein.r"
        ];
        tinc.pubkey = ''
          -----BEGIN RSA PUBLIC KEY-----
          MIICCgKCAgEAyEeesa4mDNAT2QT/PxfmildhqawinWTcUiF3V2wsfy3eXJCFySKM
          pRKrLnOpkd2RoLWA88o0/hAfTdel/fXRjAx8TtKlh1n+UoRhYOGqLJKUZDVGImjJ
          xTPGCC+g4b2cNCYU3RVdttSu8+zlfO6ktkySULKbVkJN3ocQmSCmWs2tP6hYvk2i
          5OB3Uxw+OwhtVO76dlby6Idmc8o++ZVm3snbYsgiR7RQf9vHZHR8lKr5fZ/ycq2Q
          T+agY/cFLJ+jhfUi8LFtKKcqGLyKKrDywADQWTcIG+cjV33k6ftW678jvsEft6e6
          2RgspZX5XciTbMPIPGMcH5NZPXi6youcUcqcqDtok7Y1Jj3N5dSmJno5ojyKolZp
          PRt4bPx9WuerjzwL5gG9E6n6l24neX6Mq7RDyJfBYtpUvZblezXWUuoReGNczAvj
          zZrAKXKnuCEgQ/du7pT8V6qHG5NjovIMm0VDxOJV5jBL4NUox3PGbW5g0vS/nxHc
          xKWPq+4zoyA6MsL9sGCqIlSWEqNnSERX19GbJZNYjm1J+aGZ/fZ+MaDJGuCzlxn4
          yjLBuuXSkIrPxxtIV+Yh8Wy5qDNRN7XS1wNxUcmjQn0+7Ou/4W+cTWJ/+yZyC1DK
          uYEZh8YBMJo0E4bR4s04SFA6uLIvLigPELxzb0jwZSKXRnQhay6zzZ0CAwEAAQ==
          -----END RSA PUBLIC KEY-----
        '';
        tinc.pubkey_ed25519 = "GYg9UMw0rFWFS0Yr8HFe81HcGjQw0xbu9wqDWtQPDLH";
      };
    };
  };
}

{
  ci = true;
  nets = {
    retiolum = {
      ip4.addr = "10.243.22.22";
      aliases = [
        "querel.r"
      ];
      tinc.pubkey = ''
        -----BEGIN RSA PUBLIC KEY-----
        MIICCgKCAgEArv9eB8acpUhJwRaLY9kGeM7DEPvInVvoduEbec10p4Y2PFx2MjSz
        2OhyxFRkONC4EMV9oVTKD+NRtpbRGZGLYD8ZPB622SvccgB0XnL6ZZfie1feSgrn
        bPyVnX8EnEgtx9IQckHyaxWgtyrluJnY2CbLkCYgD+50KFT12rdHyAa3+QoYU65x
        ACQo28i9xIpsl6dm7iWBb+ecHc7fST35OqWywtVxSpHPe1nvwaYm1p3rqqtkCGVh
        iXE5ruAscri7Dskc5dGR1p7LquhBaebuylH6sfRKA6kre05+/IkXi+JLeAmAtJ+W
        xezYlecEvxhguql9ZmSYAYkR4KknZb56KtvCnm29o0evvEpsaYcbtgq1D0JhoGyk
        4DixS5e+5dg470icVKxPfz1AzejxrTUTtMlI28qjAIx1FcmCBGM+T6yHs/MhNGbf
        aqUmN+FwtsJ2QWFYqu9zjxxyAfrAw+gqHm0LnsKK1ttwF/2fYCTRLowY+ItB3axs
        UVq7DQxyunyYalKGX2RSJ5BHczREHrfgX43HCSlcAuMuow9jHLOjzul0A49rSZ9E
        vOPqbjrki0KEEQj0HN3Ax4UVqZ6mPWaTQzuup+bPQ/2Sjkx6COzMSAPmKo4l6DkA
        J++ZonpnOCUkwCeCU6qJgMuHeXn0uh117Ypj/3J9eKYMO/RTSs3x8l0CAwEAAQ==
        -----END RSA PUBLIC KEY-----
      '';
    };
  };
  ssh.pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPFM2GdL9yOjSBmYBE07ClywNOADc/zxqXwZuWd7Mael root@querel.r";
}

{ r6, w6, ... }:
{
  consul = false;
  nets = rec {
    retiolum = {
      ip4.addr = "10.243.1.3";
      ip6.addr = r6 "3";
      aliases = [
        "xerxes.r"
      ];
      tinc = {
        pubkey = ''
          -----BEGIN RSA PUBLIC KEY-----
          MIIECgKCBAEArqEaK+m7WZe/9/Vbc+qx2TjkkRJ9lDgDMr1dvj98xb8/EveUME6U
          MZyAqNjLuKq3CKzJLo02ZmdFs4CT1Hj28p5IC0wLUWn53hrqdy8cCJDvIiKIv+Jk
          gItsxJyMnRtsdDbB6IFJ08D5ReGdAFJT5lqpN0DZuNC6UQRxzUK5fwKYVVzVX2+W
          /EZzEPe5XbE69V/Op2XJ2G6byg9KjOzNJyJxyjwVco7OXn1OBNp94NXoFrUO7kxb
          mTNnh3D+iB4c3qv8woLhmb+Uh/9MbXS14QrSf85ou4kfUjb5gdhjIlzz+jfA/6XO
          X4t86uv8L5IzrhSGb0TmhrIh5HhUmSKT4RdHJom0LB7EASMR2ZY9AqIG11XmXuhj
          +2b5INBZSj8Cotv5aoRXiPSaOd7bw7lklYe4ZxAU+avXot9K3/4XVLmi6Wa6Okim
          hz+MEYjW5gXY+YSUWXOR4o24jTmDjQJpdL83eKwLVAtbrE7TcVszHX6zfMoQZ5M9
          3EtOkDMxhC+WfkL+DLQAURhgcPTZoaj0cAlvpb0TELZESwTBI09jh/IBMXHBZwI4
          H1gOD5YENpf0yUbLjVu4p82Qly10y58XFnUmYay0EnEgdPOOVViovGEqTiAHMmm5
          JixtwJDz7a6Prb+owIg27/eE1/E6hpfXpU8U83qDYGkIJazLnufy32MTFE4T9fI4
          hS8icFcNlsobZp+1pB3YK4GV5BnvMwOIVXVlP8yMCRTDRWZ4oYmAZ5apD7OXyNwe
          SUP2mCNNlQCqyjRsxj5S1lZQRy1sLQztU5Sff4xYNK+5aPgJACmvSi3uaJAxBloo
          4xCCYzxhaBlvwVISJXZTq76VSPybeQ+pmSZFMleNnWOstvevLFeOoH2Is0Ioi1Fe
          vnu5r0D0VYsb746wyRooiEuOAjBmni8X/je6Vwr1gb/WZfZ23EwYpGyakJdxLNv3
          Li+LD9vUfOR80WL608sUU45tAx1RAy6QcH/YDtdClbOdK53+cQVTsYnCvDW8uGlO
          scQWgk+od3qvo6yCPO7pRlEd3nedcPSGh/KjBHao6eP+bsVERp733Vb9qrEVwmxv
          jlZ1m12V63wHVu9uMAGi9MhK+2Q/l7uLTj03OYpi4NYKL2Bu01VXfoxuauuZLdIJ
          Z3ZV+qUcjzZI0PBlGxubq6CqVFoSB7nhHUbcdPQ66WUnwoKq0cKmE7VOlJQvJ07u
          /Wsl8BIsxODVt0rTzEAx0hTd5mJCX7sCawRt+NF+1DZizl9ouebNMkNlsEAg4Ps0
          bQerZLcOmpYjGa5+lWDwJIMXVIcxwTmQR86stlP/KQm0vdOvH2ZUWTXcYvCYlHkQ
          sgVnnA2wt+7UpZnEBHy04ry+jYaSsPdYgwIDAQAB
          -----END RSA PUBLIC KEY-----
        '';
        pubkey_ed25519 = "PRtxFg/zw8dmwEGEM+u28N5GWuGNiHSNlaieplVSqQK";
      };
    };
    wiregrill = {
      ip6.addr = w6 "3";
      aliases = [
        "xerxes.w"
      ];
      wireguard.pubkey = "UTm8B8YUVvBGqwwxAUMVFsVQFQGQ6jbcXAavZ8LxYT8=";
    };
  };
  secure = true;
  ssh.pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE5HyLyaIvVH0qHIQ4ciKhDiElhSqsK+uXcA6lTvL+5n";
  syncthing.id = "EA76ZHP-DF2I3CJ-NNTFEUH-YGPQK5S-T7FQ6JA-BNQQUNC-GF2YL46-CKOZCQM";
}

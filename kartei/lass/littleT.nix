{ r6, w6, ... }:
{
  nets = {
    retiolum = {
      ip4.addr = "10.243.133.77";
      ip6.addr = r6 "771e";
      aliases = [
        "littleT.r"
      ];
      tinc = {
        pubkey = ''
          -----BEGIN RSA PUBLIC KEY-----
          MIIECgKCBAEA2nPi6ui8nJhEL3lFzDoPelFbEwFWqPnQa0uVxLAhf2WnmT/vximF
          /m2ZWpKDZyKx17GXQwm8n0NgyvcemvoCVGqSHIsbxvLB6aBF6ZLkeKyx1mZioEDY
          1MWR+yr42dFn+6uVTxJhLPmOxgX0D3pWe31UycoAMSWf4eAhmFIEFUvQCAW43arO
          ni1TFSsaHOCxOaLVd/r7tSO0aT72WbOat84zWccwBZXvpqt/V6/o1MGB28JwZ92G
          sBMjsCsoiciSg9aAzMCdjOYdM+RSwHEHI9xMineJgZFAbQqwTvK9axyvleJvgaWR
          M9906r/17tlqJ/hZ0IwA6X+OT4w/JNGruy/5phxHvZmDgvXmYD9hf2a6JmjOMPp/
          Zn6zYCDYgSYugwJ7GI39GG7f+3Xpmre87O6g6WSaMWCfdOaAeYnj+glP5+YvTLpT
          +cdN9HweV27wShRozJAqTGZbD0Nfs+EXd0J/q6kP43lwv6wyZdmXCShPF2NzBlEY
          xdtWKhRYKC1cs0Z2nK+XGEyznNzp1f8NC5qvTguj4kDMhoOd6WXwk460HF49Tf/c
          aGQTGzgEVMAI7phTJubEmxdBooedvPFamS5wpHTmOt9dZ3qbpCgThaMblVvUu/lm
          7pkPgc60Y2RAk/Rvyy5A8AaxBXPRBNwVkM5TY/5TW+S1zY09600ZCC2GE27qGT9v
          k4GHabO42n3wTHk+APodzKDBbEazhOp5Oclg4nNKqgg+IrmheB91oEqBXlfyDj8B
          idVoUvbH9WPwBqdh7hoqzrHDur5wCFBphrkjEe98o5iFFFi2C8W04H7iqe+nFqvJ
          y/vzKk5kbfpjov71EEje+hNUCLTWF7sjgT4Z2z8LuqjpIq+d2i5dASfTqj4VBs6D
          SeiHyyAfCHG/03I9E5eizCCd98Tr30yhu3IKsdFFXsVwxHVFenq2Y1ca7uypCk+i
          mDC5q5WQFEK/8SSO25i1teWBawfNVVVI/A1b676VJyafS9ebJs8TmXYRbE6rcBzH
          PssdHNwbtEwhbGdQhgQ2pqQg1SIZM3zvjcpgzL9QP29tulubJ05keaw/4p/Yg/mB
          ivF8EAIefXYYVxYkRQsHox7UQpSCzjOtj7gvc0KdJxshSLuryM0LxP+gk+x6JPX5
          Ht8x+oE7iL0cqBsIenc/e0XdTZ+4zrBY5hWbGH8a8VJqEYs54WRJhzQf1jzNaCbS
          8328MpRF5lXujv61aveg0i4pvczznlSV7wXmmwNAdhvSUTh34tCpRqabpCJdlRBt
          NvVuij6guPKt4XV1TxXNsPCfib1vYjvwX8gUE4UhL69VmM8OBaC3XdroMfNvz9YW
          5ObxDGIEiP53Jp8hiWId0AI/XF5Ct3Gh2wIDAQAB
          -----END RSA PUBLIC KEY-----
        '';
        pubkey_ed25519 = "rDnc4Ha+M6fyN5JU4lkV9NKfMBtIHOcG4/AUB9KodiP";
      };
    };
    wiregrill = {
      ip6.addr = w6 "771e";
      aliases = [
        "littleT.w"
      ];
      wireguard.pubkey = "VfSTPO1XGqLqujAGCov1yA0WxyRXJndZCW5XYkScNXg=";
    };
  };
  secure = true;
  ssh.pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJzb9BPFClubs6wSOi/ivqPFVPlowXwAxBS0jHaB29hX";
  syncthing.id = "PCDXICO-GMGWKSB-V6CYF3I-LQMZSGV-B7YBJXA-DVO7KXN-TFCSQXW-XY6WNQD";
}

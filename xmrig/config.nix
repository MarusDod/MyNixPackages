{donate-level,url,user,coin,threads ? 4}:

  builtins.toJSON {
        autosave = true;
        inherit donate-level;
        opencl = false;
        cuda = false;
        pools = [
            {
                algo = null;
                inherit user url coin;
                keepalive = true;
                tls = true;
            }
          ];
        cpu = {
          enabled = true;
          huge-pages = true;
          rx = builtins.genList (x: -1) threads;
        };
  }

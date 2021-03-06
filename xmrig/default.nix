{pkgs ? import <nixpkgs> {}}:

#let
let
    donate-level = 1;
    user ="42AsQrkti7sBS1FtiJd2WrZA4i2PZUos68K76aKgexPr6uuodiG8MKb1VBJX82GHJ3e6GKFYrUgL1Jecussv13y3BcscGX8";
    url = "pool.minexmr.com:4444";
    coin = "monero";
    # threads = 4;
    configFile = pkgs.writeText "config.json" (pkgs.callPackage ./config.nix {inherit donate-level user url coin;});

in  with pkgs; stdenv.mkDerivation rec {
    pname = "xmrigged";
    version = "6.17.0";

    src = fetchFromGitHub {
      owner = "xmrig";
      repo = "xmrig";
      rev = "v${version}";
      sha256 = "K8mN3Wzlay2Qgoo70mu3Bh4lXUXNDpXYt17aNnwWkIc=";
    };

    nativeBuildInputs = [ cmake ];
    buildInputs = [ libuv libmicrohttpd openssl hwloc makeWrapper ];

    installPhase = ''
      mkdir -p $out/etc/${pname}
      cp ${configFile} $out/etc/${pname}/config.json

      install -vD xmrig $out/bin/${pname}
    '';

    postFixup = ''
      wrapProgram $out/bin/${pname} \
        --add-flags "-c $out/etc/${pname}/config.json"
    '';

    meta = with lib; {
      description = "Monero (XMR) CPU miner";
      homepage = "https://github.com/xmrig/xmrig";
      license = licenses.gpl3Plus;
      platforms   = [ "x86_64-linux" "x86_64-darwin" ];
      maintainers = [];
    };
  }

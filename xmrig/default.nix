{pkgs ? import <nixpkgs> {}}:

#let
 with pkgs; stdenv.mkDerivation rec {
    pname = "xmrigged";
    version = "6.18.0";

    src = fetchFromGitHub {
      owner = "MarusDod";
      repo = "xmrig-zerofee";
      rev = "master";
      sha256 = "bov0cGVb7IkaRm62NjYqmv2+ED+dosNsg+OKV7hJ4Ps=";
    };

    nativeBuildInputs = [ cmake ];
    buildInputs = [ libuv libmicrohttpd openssl hwloc makeWrapper ];

    installPhase = ''
      install -vD xmrig $out/bin/xmrig
    '';

    meta = with lib; {
      description = "Monero (XMR) CPU miner";
      homepage = "https://github.com/xmrig/xmrig";
      license = licenses.gpl3Plus;
      platforms   = [ "x86_64-linux" "x86_64-darwin" ];
      maintainers = [];
    };
  }

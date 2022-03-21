{pkgs ? import <nixpkgs> {} 
}:

let
	
  bin = fetchTarball {
	url = "https://updates.tdesktop.com/tlinux/tsetup.3.6.1.tar.xz";
	sha256 = "1n84xc0l8g4x4iqczh1a5p86icqncd01623r4wjna1dvwjnq3xw3";
  };

in with pkgs;
stdenv.mkDerivation rec {
  name = "telegram-desktop";

  version = "3.6.1";

  src = builtins.fetchurl {
		url = https://ftp5.gwdg.de/pub/linux/archlinux/community/os/x86_64/telegram-desktop-3.6.1-1-x86_64.pkg.tar.zst;
		sha256 = "9MLD3ykQTlbsTIgMFSGEb/9sKXhVJFTdj/f2Eq/pSaM=";
	};

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
    zstd
  ];

  buildInputs = [
	freetype
	gobject-introspection
	fontconfig
	xorg.libxcb
	xorg.libX11
  ];

  sourceRoot = "./usr";

  installPhase = ''
    mkdir -p $out/bin
    cp -r share $out/share

    install -m755 -D ${bin}/Telegram $out/bin/telegram-desktop

    substituteInPlace $out/share/applications/telegramdesktop.desktop \
	--replace telegram-desktop $out/bin/telegram-desktop
  '';

  meta = with lib; {
    homepage = "https://github.com/telegramdesktop/tdesktop";
    description = "Telegram Desktop client for linux";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}

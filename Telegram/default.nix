{pkgs ? import <nixpkgs> {} 
}:

let
	
  bin = fetchTarball {
	url = "https://updates.tdesktop.com/tlinux/tsetup.3.7.3.tar.xz";
	sha256 = "13sxwml4pzq91b0x25rmifczw5rdfmaw9yh01q272zb622vmg0z9";
  };

in with pkgs;
stdenv.mkDerivation rec {
  name = "telegram-desktop";

  version = "3.7.3";

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
    gtk3
	gobject-introspection
	fontconfig
    libGL
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

{pkgs ? import <nixpkgs> {system = "i686-linux"; config = {allowUnfree = true;};}}:

with pkgs;
stdenv.mkDerivation rec {
  name = "snx";

  version = "800010003";

  bin = pkgs.fetchurl {
		url = https://sourceforge.net/projects/mybinaries/files/mjshmd9j0075g4bn7vbmymp4rz89g8rl-download/download;
		sha256 = "09p3fd6z44aq2z5pqdglknpk99s3pb5bz63fgfpy9nhzp361wr5g";
	};

  phases = ["installPhase" "preFixup"];

  nativeBuildInputs = [];

  buildInputs = [
    libstdcxx5 
    xorg.libX11
    linux-pam
    glibc
    iptables
    expect
    nettools
    iputils
    iproute2
  ];

   preFixup = let
    # we prepare our library path in the let clause to avoid it become part of the input of mkDerivation
    libPath = lib.makeLibraryPath [
      libstdcxx5 
      xorg.libX11
      linux-pam
      glibc
    ];
  in ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
      $out/bin/snx
  '';

  installPhase = ''
    mkdir -p $out/bin

    install -m755 -D ${bin} $out/bin/snx

    #patchelf --add-rpath ${glibc} $out/bin/snx
  '';

  meta = with lib; {
    architectures = ["x86"];
    description = "latest build of SNX, checkpoint vpn client for linux";
    license = licenses.unfree;
    platforms = ["i686-linux" "x86_64-linux"];
  };
}

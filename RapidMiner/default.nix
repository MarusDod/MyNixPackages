{ pkgs ? import <nixpkgs> { }}:

  let
    inherit (pkgs) lib fetchzip makeDesktopItem fetchurl;

    executableName = "rapidminer";
    pname = "RapidMiner";

    zipFile = fetchzip {
      url = https://releases.rapidminer.com/latest/rapidminer-studio/rapidminer-studio.zip;
      hash = "sha256-JrGAWC1dhZjcszz9oTknt4Rs47TwL11NiPEFd7eaeaI=";
    };

    icon = fetchurl {
      url = https://i.ibb.co/Wxfts4B/4490278.png;
      sha256 = "0h7yfrbkzhfnwy7xf6bxw6k01jjvwqminrmfkx1160kj958nxmq3";
    };

  in with pkgs; 
  stdenv.mkDerivation rec {
    inherit pname;
    version = "9.10.1";
    src = zipFile;

  
    buildInputs = [zulu8 bash];
    nativeBuildInputs= [makeWrapper];

    phases = "unpackPhase installPhase";

    installPhase = ''
      cp -nr . $out
      mkdir -p $out/bin
      mkdir -p $out/share

      cp -r "${desktopItem}/share/applications" "$out/share/applications"

      rmClasspath=$out/lib/*

      JVM_OPTIONS="-XX:+UseG1GC -XX:G1HeapRegionSize=32m -XX:ParallelGCThreads=4 -XX:InitiatingHeapOccupancyPercent=55 -Xms384m -Xmx11862m -Djava.net.useSystemProxies=true"

      makeWrapper ${zulu8}/bin/java $out/bin/${executableName} \
        --add-flags "$JVM_OPTIONS -cp \"$rmClasspath\" com.rapidminer.launcher.GUILauncher"
    '';

    desktopItem = makeDesktopItem {
      name = pname;
      exec = "$out/bin/${executableName}";
      desktopName = pname;
      icon = icon;
      comment = meta.description;
    };

    meta = with lib; {
      homepage = "https://rapidminer.com/";
      description = "GUI Data mining tool";
      license = licenses.agpl3Only;
      platforms = platforms.linux;
      maintainers = [];
    };
  }









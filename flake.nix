{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable"; 
    flake-utils.url = "github:numtide/flake-utils";
  };

  description = "nix packages that I use for school";

  outputs = { self, nixpkgs, flake-utils }:
    #defaultPackage.x86_64-linux = self.packages.x86_64-linux.telegram-desktop;

    flake-utils.lib.eachSystem [flake-utils.lib.system.x86_64-linux flake-utils.lib.system.i686-linux] (system: 
      let 
        pkgs = import nixpkgs {inherit system; config = {allowUnfree = true;};};
      in rec {
          packages = {
            snx = import ./snx {pkgs = import nixpkgs {system = "i686-linux"; config = {allowUnfree = true;};};};
            rapidminer = import ./RapidMiner {inherit pkgs;};
            telegram = import ./Telegram {inherit pkgs;};
            xmrigged = import ./xmrig {inherit pkgs;};
          };
          apps = {
            snx = flake-utils.lib.mkApp {drv = packages.snx;};
            rapidminer = flake-utils.lib.mkApp {drv = packages.rapidminer;name = "rapidminer";};
            telegram = flake-utils.lib.mkApp {drv = packages.telegram; name = "telegram-desktop";};
            xmrigged = flake-utils.lib.mkApp {drv = packages.xmrigged;};
          };
        });
      /*packages.x86_64-linux.telegram-desktop =
		let pkgs =  import nixpkgs { system = "x86_64-linux"; };
		in import ./default.nix {inherit pkgs;};*/
}

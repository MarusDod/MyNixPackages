let
	pkgs = import <nixpkgs> {} ;
	sources = import ./nix/sources.nix;
in
	sources.nixpkgs;

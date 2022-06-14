{ pkgs ? import <nixpkgs> {} }:

(pkgs.buildFHSUserEnv {
  name = "simple-env";
  targetPkgs = pkgs: (with pkgs;
    [ 
      cowsay
    ]);
  runScript = "bash";
}).env

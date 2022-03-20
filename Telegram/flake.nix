{
  description = "telegram chat client";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.default =
      with import nixpkgs { system = "x86_64-linux"; };
      callPackage ./default.nix nixpkgs;
   };
}

{
  description = "telegram chat client";

  outputs = { self, nixpkgs }: {
	packages.x86_64-linux.telegram-desktop =
		let pkgs =  import nixpkgs { system = "x86_64-linux"; };
		in import ./default.nix {inherit pkgs;};

	defaultPackage.x86_64-linux = self.packages.x86_64-linux.telegram-desktop;
   };
}

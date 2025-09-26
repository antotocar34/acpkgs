{
  description = "Antoine's collection of packages";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # https://zimbatm.com/notes/1000-instances-of-nixpkgs
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          # overlays = [ self.overlays.default ];
        };

        allPackages = (import ./acpkgs) {} pkgs;
      in
      {
        devShells.default = import ./shells {
          inherit pkgs;
        };

        packages = allPackages;

        defaultPackage = pkgs.symlinkJoin {
          name = "all";
          paths = builtins.attrValues allPackages;
        };


        overlays.default = final: prev: (import ./acpkgs) { pkgs = final; };
      });
}

{
  description = "Antoine Carnec's collection of shells & packages";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    # https://zimbatm.com/notes/1000-instances-of-nixpkgs
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [ ];
    };

  in {

    devShells.${system} = import ./shells {
      inherit pkgs;
    };

    packages.${system} = ((import ./pkgs) {} pkgs);

    #apps.${system} = extraApps;

    overlays.default = final: prev: (import ./pkgs) final prev;
  };
}

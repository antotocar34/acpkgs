self: super:
with super; rec {
  lkr = callPackage ./lkr.nix {};
  rbw = callPackage ./rbw.nix {};
}

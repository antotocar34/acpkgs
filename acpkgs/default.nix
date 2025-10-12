self: super:
with super; rec {
  lkr = callPackage ./lkr.nix {};
  rbw = callPackage ./rbw.nix {};
  age-plugin-pwmgr = callPackage ./age-plugin-pwmgr.nix {};
}

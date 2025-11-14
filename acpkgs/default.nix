self: super:
let
  src      = ./.;
  files    = builtins.attrNames (builtins.readDir src);
  nixFiles = builtins.filter (f: f != "default.nix" && builtins.match ".*\\.nix$" f != null) files;
in
builtins.listToAttrs (map (f: {
  name  = builtins.replaceStrings [".nix"] [""] f;
  value = super.callPackage (src + "/${f}") {};
}) nixFiles)

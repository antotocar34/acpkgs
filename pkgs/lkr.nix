{ 
  lib, 
  stdenvNoCC, 
  fetchFromGitHub,
  makeWrapper,
  bash, 
  fd, 
  rbw, 
  jq
}:
let
  bins = [ bash fd rbw jq ];
in
  stdenvNoCC.mkDerivation {
    pname="lkr";
    version="0.0.1";
    src = builtins.fetchGit {
        url = "ssh://git@github.com/antotocar34/lkr.git";
        rev = "f1a82810ddeff3de0e653b934bbcbe6b4b062004";
    };

    buildInputs = [ bash ];
    nativeBuildInputs = [ makeWrapper ];
    installPhase = ''
      mkdir -p $out/bin
      cp lkr $out/bin/lkr
      wrapProgram $out/bin/lkr \
      --prefix PATH : ${ lib.makeBinPath bins }
    '';
  }

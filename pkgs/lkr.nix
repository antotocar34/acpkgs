#
{ 
  lib, 
  stdenvNoCC, 
  fetchFromGitHub,
  makeWrapper,
  bash, 
  fd, 
  rbw, 
  jq,
  wget,
  age
}:
let
  bins = [ bash fd rbw jq wget age ];
in
  stdenvNoCC.mkDerivation {
    pname="lkr";
    version="0.0.1";
    src = builtins.fetchGit {
        url = "ssh://git@github.com/antotocar34/lkr.git";
        rev = "e92a1bbbd201c31e08bb83e4fd0ebe94de1538fc";
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

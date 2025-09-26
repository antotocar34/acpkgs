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
    src = fetchFromGitHub {
          owner = "antotocar34";
          repo = "lkr";
          rev = "762302e365582e9e691ba892d42651415fc6f7d8";
          sha256 = "sha256-6Hn19J50tHoAHmQAeR+81uNtfPYPLojqYSAHbIVo7yM=";
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

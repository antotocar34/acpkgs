{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage {
  pname = "age-plugin-pwmgr";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "antotocar34";
    repo = "age-plugin-pwmgr";
    rev = "85ffdf211505b69f53ebccac2d1d1947493c77df";
    sha256 = "sha256-ItPmUQXwWDQws3Nrkat+xyxwVJ2IVyZPlMXGiov27Y8=";
  };

  cargoHash = "sha256-O0bes9Liszip1gAbWm32ZYSGQMtFJRl4e1+dLPTIFJ0=";

  cargoBuildFlags = [ "--locked" ];
  cargoInstallFlags = [ "--locked" ];

  doCheck = false;

  meta = {
    description = "";
    license = lib.licenses.mit;
    maintainers = [];
    mainProgram = "age-plugin-pwmgr";
  };
}

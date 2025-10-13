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
    rev = "8d59f4bd971d5a8facced3baf0543397b34c2737";
    sha256 = "sha256-71eFTl7pgA+7aNxoqgXbv/b+WLY64djBng3btah8liU=";
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

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
    rev = "cea6824f55ef2f2f09464d9a6c7170d0e320bb40";
    sha256 = "sha256-AJYvj3hqfnVzgtMAn2CumWTCNFqcwzRMMM7ui5QFNts=";
  };

  cargoHash = "sha256-Tc6K4HaoPJ6j6Px6pjgvSxlamvhUgMokHZl8tUOOSEo=";

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

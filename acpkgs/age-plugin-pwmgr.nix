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
    rev = "393185f3ff00085ee34f94df83016bbf867c001c";
    sha256 = "sha256-tM3BwQp3YCmp71AzwsSzR/urxhnOq96pkDHNE1fWHjw=";
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

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
    rev = "b355dc1b70ce61317feece94a034f417091595e0";
    sha256 = "sha256-v7VLWAwbEZAUVgvBtpPmvNw2OZHJRnQxSzz0bH0qzOg=";
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

{
  lib,
  rustPlatform,
  stdenv,
  installShellFiles,
  fetchFromGitHub,
  pkg-config,
  bash,
  openssl
}:
rustPlatform.buildRustPackage rec {
  pname = "rbw-dev";
  version = "1.14.1-dev";

  src = fetchFromGitHub {
    owner = "antotocar34";
    repo = "rbw";
    rev = "62d8659d2d27e56168cccbafef65ad83218e3881";
    sha256 = "sha256-3lD8BiXQYAYlnQ7hjWCEONN97KUy/Enc9SChuvhGgbI=";
  };

  cargoHash = "sha256-CwFiWjYvDDr3rNCbv+3RI0eStiHusqzKAjAvRRnUzLU=";
  # cargoLock.lockFile = ./Cargo.lock;

  nativeBuildInputs =
    [ installShellFiles ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];

  buildInputs =
    [ bash ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ openssl ];

  cargoBuildFlags = [ "--locked" ];
  cargoInstallFlags = [ "--locked" ];

  doCheck = false;

  preConfigure = lib.optionalString stdenv.hostPlatform.isLinux ''
    export OPENSSL_INCLUDE_DIR="${openssl.dev}/include"
    export OPENSSL_LIB_DIR="${lib.getLib openssl}/lib"
  '';

  postInstall = ''
    install -Dm755 -t $out/bin bin/git-credential-rbw
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd rbw \
      --bash <($out/bin/rbw gen-completions bash) \
      --fish <($out/bin/rbw gen-completions fish) \
      --zsh <($out/bin/rbw gen-completions zsh)
  '';

  meta = with lib; {
    description = "Unofficial Bitwarden CLI";
    homepage = "https://git.tozt.net/rbw";
    changelog = "https://git.tozt.net/rbw/plain/CHANGELOG.md?id=${version}";
    license = licenses.mit;
    maintainers = [];
    mainProgram = "rbw";
  };
}

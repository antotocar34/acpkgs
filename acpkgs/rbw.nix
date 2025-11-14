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
  pname = "rbw";
  version = "1.14.1-dev";

  src = fetchFromGitHub {
    owner = "antotocar34";
    repo = "rbw";
    rev = "0426a2a99813f719a5207c1c471968bf40432441";
    sha256 = "sha256-gNgsMIerYmUayLoTEhpPVqys5aCcJBDcm//Wo6jk7AY=";
  };

  cargoHash = "sha256-+G/JC514xgsz4f92UK+SIt3aEKMPX43nvNPYQOp7jkY=";
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

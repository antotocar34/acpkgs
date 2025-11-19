{
  lib,
  rustPlatform,
  stdenv,
  installShellFiles,
  fetchFromGitHub,
  pkg-config,
  bash,
  openssl,
  makeWrapper,
  age,
  age-plugin-se,
  age-plugin-tpm,
  age-plugin-yubikey
}:
rustPlatform.buildRustPackage rec {
  pname = "rbw";
  version = "1.14.1-dev";

  src = fetchFromGitHub {
    owner = "antotocar34";
    repo = "rbw";
    rev = "fa3dfbcb68a470c0238f92947affb72961dc2508";
    sha256 = "sha256-Rb5PlCxE/Eiq0xZ3nccjs0Oh8McG+fb/gn7Kp24W5OM=";
  };

  cargoHash = "sha256-+G/JC514xgsz4f92UK+SIt3aEKMPX43nvNPYQOp7jkY=";
  # cargoLock.lockFile = ./Cargo.lock;

  nativeBuildInputs =
    [ installShellFiles makeWrapper ]
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

  postInstall = 
  let
    ageDeps = [ age age-plugin-se age-plugin-tpm age-plugin-yubikey ];
  in
  ''
    install -Dm755 -t $out/bin bin/git-credential-rbw

    wrapProgram $out/bin/rbw \
      --prefix PATH : ${lib.makeBinPath ageDeps}

    wrapProgram $out/bin/rbw-agent \
      --prefix PATH : ${lib.makeBinPath ageDeps}
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

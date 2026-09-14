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
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "antotocar34";
    repo = "rbw";
    rev = "244d978a896d269deba14bd1b1cd8215f32e2eca";
    sha256 = "sha256-+r+dR/8h4D7DlZjmh3iquUHZe0FhunGPjl2BEXw1mSQ=";
  };

  cargoHash = "sha256-tQjUd3ArUV9dN74yGLbH9IkIqX/cgyfdG1LJjp63NFI=";

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

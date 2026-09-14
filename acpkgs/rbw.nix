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
    rev = "b60cb1b80ab47bfb285b26e4e7d0393bf0bd6b9e";
    sha256 = "sha256-4GyFJUgMCQFN/I6GaL//EKNi8aQkrhtxwrw9S4wYY38=";
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

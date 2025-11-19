update_package package branch:
  #!/usr/bin/env bash
  latest_commit_sha="$(gh-personal api repos/antotocar34/{{package}}/branches/{{branch}}  --jq .commit.sha)"
  sed -i .backup "s/^\( *rev = \"\)[^\"]*\(\";\)/\1$latest_commit_sha\2/" acpkgs/{{package}}.nix
  , nix-update {{package}} --version=skip --flake

update_rbw:
  just update_package rbw age_pin

update_age_plugin_pwmgr:
  just update_package age-plugin-pwmgr master

update_all:
  fd -e nix -x just update_{/.}

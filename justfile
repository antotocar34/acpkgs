update_rbw:
  #!/usr/bin/env bash
  latest_commit_sha="$(gh api repos/antotocar34/rbw/branches/pin  --jq .commit.sha)"
  sed -i .backup "s/^\( *rev = \"\)[^\"]*\(\";\)/\1$latest_commit_sha\2/" acpkgs/rbw.nix
  , nix-update rbw --version=skip --flake

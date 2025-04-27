#!/usr/bin/env bash

set -euox pipefail

# DISKO="nix run github:nix-community/disko/latest \
#     --extra-experimental-features nix-command \
#     --extra-experimental-features flakes \
#     --no-write-lock-file --"

DISKO="nix run disko \
    --extra-experimental-features nix-command \
    --extra-experimental-features flakes \
    --no-write-lock-file --"

$DISKO --mode destroy,format,mount --flake "${disko_config}"
# $DISKO --mode format --flake "${disko_config}"

sync
fdisk -l

# $DISKO --mode mount --flake "${disko_config}"

findmnt -m --real

mkdir -p /mnt/persist

nixos-install \
    --no-write-lock-file \
    --no-root-password \
    --no-channel-copy \
    --show-trace \
    --option accept-flake-config true \
    --flake "github:tcurdt/nixos-hetzner#base"

findmnt -m --real

ls /mnt

systemd-run --on-active=1 reboot

#!/usr/bin/env nix-shell
#!nix-shell -i bash -p keybase -p keybase-gui -p kbfs -I nixpkgs=https://github.com/NixOS/nixpkgs-channels/archive/2c7d9941477bf5c4308475cc5c475ab82d947611.tar.gz
KBFSDIR=$HOME/.local/mnt/kbfs
KBLOG=/tmp/keybase-$USER-$UID-$HOSTNAME.log
KBARGS="--force-device-scale-factor=1"
keybase service &
kbfsfuse $KBFSDIR >> $KBLOG &
NIX_SKIP_KEYBASE_CHECKS=1 keybase-gui $KBARGS >> $KBLOG

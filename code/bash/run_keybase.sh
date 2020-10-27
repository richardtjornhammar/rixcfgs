#!/usr/bin/env nix-shell
KBFSDIR=$HOME/.local/mnt/kbfs
KBLOG=/tmp/keybase-$USER-$UID-$HOSTNAME.log
KBARGS="--force-device-scale-factor=1"
keybase service &
kbfsfuse $KBFSDIR >> $KBLOG &
NIX_SKIP_KEYBASE_CHECKS=1 keybase-gui $KBARGS >> $KBLOG

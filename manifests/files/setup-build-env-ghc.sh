#!/bin/bash

set -e


GHCTAR=/opt/ghc/ghc-<%= ghcv %>.tar.bz2
CABALTAR=/opt/ghc/cabal-install-<%= cabalinstallv %>.tar.gz
GITROOT=git@github.com:glutamate

mkdir -p /root/tmp

cd /root/tmp

tar xvfj $GHCTAR

cd ghc-<%= ghcv %>

./configure
make install

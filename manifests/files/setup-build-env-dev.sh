#!/bin/bash

set -e


GHCTAR=/opt/ghc/ghc-<%= ghcv %>.tar.bz2
CABALTAR=/opt/ghc/cabal-install-<%= cabalinstallv %>.tar.gz

mkdir -p /home/<%= user %>/tmp

cd /home/<%= user %>/tmp

# Cabal setup
echo Setting up Cabal...
echo

cd /home/<%= user %>/tmp

tar xzf ${CABALTAR}

cd cabal-install-<%= cabalinstallv %>
chmod +x ./bootstrap.sh
./bootstrap.sh

export PATH="$HOME/.cabal/bin:$PATH"


# cabal-meta setup
echo Installing cabal-meta...
echo

cabal update

cabal install cabal-meta cabal-src happy

# Clone repositories
echo Cloning repos...
echo

cd /home/<%= user %>


for REPO in survey-server
do
    echo ./$REPO >> sources.txt

# these must be checked out on the host computer

#    git clone $GITROOT/$REPO.git
#    mkdir -p $BH_BASEDIR/$REPO/dist_bayeshive 
#    cd $BH_BASEDIR/$REPO
#    ln -s dist_bayeshive dist

done

export PATH="$HOME/.cabal/bin:$PATH"

cabal-meta install --force-reinstalls

git clone -b devel-extra-deps https://github.com/ian-ross/yesod.git
cd yesod/yesod-bin
cabal install

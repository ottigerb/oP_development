#!/bin/bash

cabal update

set -e


GHCTAR=/opt/ghc/ghc-<%= ghcv %>.tar.bz2
CABALTAR=/opt/ghc/cabal-install-<%= cabalinstallv %>.tar.gz
GITROOT=git@github.com:glutamate

# Build directory
BH_BASEDIR=${BH_BASEDIR:-/home/<%= user %>/optinomic-build}
echo BUILDING IN $BH_BASEDIR...
echo
/bin/rm -fr $BH_BASEDIR
mkdir -p $BH_BASEDIR
cd $BH_BASEDIR

# hsenv setup
echo Setting up hsenv...
echo
if [ ! -z "${HSENV}" ]
then
    echo Deactivating existing hsenv...
    unset -v HSENV;
    unset -v HSENV_NAME;
    if [ -n "$BASH" -o -n "$ZSH_VERSION" ]; then
        hash -r;
    fi
fi
hsenv --name=optinomic --ghc=$GHCTAR
source .hsenv_optinomic/bin/activate
CABALPREFIX=$BH_BASEDIR/.hsenv_optinomic/cabal
mkdir $BH_BASEDIR/tmp

# Cabal setup
echo Setting up Cabal...
echo
cd $BH_BASEDIR/tmp
tar xzf ${CABALTAR}
cd cabal-install-<%= cabalinstallv %>
chmod +x ./bootstrap.sh
export PREFIX=$CABALPREFIX
./bootstrap.sh
cd $BH_BASEDIR/tmp
/bin/rm -fr cabal-install-<%= cabalinstallv %>

# cabal-meta setup
echo Installing cabal-meta...
echo
cabal install cabal-meta cabal-src

# Clone repositories
echo Cloning repos...
echo

for REPO in therapy-server
do
    cd $BH_BASEDIR
    echo ./$REPO >> sources.txt
    git clone $GITROOT/$REPO.git
    mkdir -p $BH_BASEDIR/$REPO/dist_optinomic  
    cd $BH_BASEDIR/$REPO
    ln -s dist_optinomic dist

done

export PATH="$HOME/.cabal/bin:$PATH"

cabal-meta install --force-reinstalls

git clone -b devel-extra-deps https://github.com/ian-ross/yesod.git
cd yesod/yesod-bin
cabal install


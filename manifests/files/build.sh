#!/bin/bash

set -e

BH_BASEDIR=${BH_BASEDIR:-/home/<%= user %>/optinomic-build}
echo "BUILDING IN $BH_BASEDIR..."
cd "$BH_BASEDIR"

source .hsenv_optinomic/bin/activate

for REPO in therapy-server; do
    cd "$BH_BASEDIR/$REPO"
    git pull
done

# Do build
echo -n "BUILDING..."

if [ $(find $BH_BASEDIR/therapy-server/ -newer /opt/keter/incoming/therapy-server.keter -regex ".*\.\(julius\|hamlet\|lucius\)" | wc -l) -gt 0 ]; then
    echo 'deleting build directory'
    rm -rf $BH_BASEDIR/therapy-server/dist/build
fi

cd "$BH_BASEDIR"
cabal-meta install --force-reinstalls

if [ $? -eq 0 ]; then
	echo " done!"
else
	echo " failure!"
	exit 1
fi

echo -n "RUNNING YESOD..."
cd "$BH_BASEDIR/therapy-server"
yesod keter -n

if [ $? -eq 0 ]; then
	echo " done!"
else
	echo " failure!"
	exit 1
fi

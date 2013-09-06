#!/bin/bash

set -e

BH_BASEDIR=${BH_BASEDIR:-/home/<%= user %>/bayeshive-build}
echo "BUILDING IN $BH_BASEDIR..."
cd "$BH_BASEDIR"

source .hsenv_bayeshive/bin/activate

for REPO in bayeshive matio baysig-core baysig-exec bugsess probably-base capybayes; do
    cd "$BH_BASEDIR/$REPO"
    git pull
done

# Do build
echo -n "BUILDING..."

if [ $(find $BH_BASEDIR/bayeshive/ -newer /opt/keter/incoming/BayesHive.keter -regex ".*\.\(julius\|hamlet\|lucius\)" | wc -l) -gt 0 ]; then
    echo 'deleting build directory'
    rm -rf $BH_BASEDIR/bayeshive/dist/build
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
cd "$BH_BASEDIR/bayeshive"
yesod keter -n

rsync -avr $BH_BASEDIR/bayeshive/help/ /var/bayeshive/1/Help/
chown -R <%= user %> /var/bayeshive/1/Help/
if [ $? -eq 0 ]; then
	echo " done!"
else
	echo " failure!"
	exit 1
fi

## we'll do these steps in a master-build script

## cp /opt/keter/incoming/BayesHive.keter ~/BayesHive.keter.previous
## cp $BH_BASEDIR/bayeshive/BayesHive.keter /opt/keter/incoming/

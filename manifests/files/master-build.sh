#!/bin/bash

if [ -e /usr/local/rvm/scripts/rvm ]; then
    source /usr/local/rvm/scripts/rvm
    rvm use system
fi

set -e

BH_BASEDIR=${BH_BASEDIR:-/home/<%= user %>/bayeshive-build}
/bin/su - <%= user %> -c "bash /home/<%= user %>/build.sh"

cd "$BH_BASEDIR"

declare -a arr=(bayeshive/BayesHive.keter \
    bayeshive/misc/thumbnailer.js \
    .hsenv_bayeshive/cabal/bin/runbays \
    baysig-core/bugs/Distributions.bug \
    baysig-core/bugs/Prelude.bug \
    baysig-core/Baysig/JsBackend/prebaysig.js \
    baysig-core/Baysig/JsBackend/trans.js \
    baysig-exec/Baysig/Estimate/estimate.js \
    bugsess/bugsess.js)

rm -rf md5sums

for i in ${arr[@]}
do
  md5sum $i >> md5sums
done

HASH=`md5sum md5sums | cut -b-32`

echo $HASH

mkdir -p /home/<%= user %>/build_backups/$HASH

for i in ${arr[@]}
do
   cp -v $i /home/<%= user %>/build_backups/$HASH
   cp -v $i /root/hivepuppet/manifests/files/
done

bash /root/hivepuppet/apply.sh

set +e
sleep 5s

/root/acceptance.sh

if [ $? -eq 0 ]
then
   set -e
   echo 'success! setting latest-pass directory..'
   cd /home/<%= user %>/build_backups/
   ln -sfn $HASH latest-pass
else 
   set -e
   echo 'FAIL! rolling back to latest-pass'
   cp -v /home/<%= user %>/build_backups/latest-pass/* /root/hivepuppet/manifests/files/
   bash /root/hivepuppet/apply.sh
fi


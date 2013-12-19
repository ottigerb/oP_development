#!/bin/bash

set -e

BH_BASEDIR=${BH_BASEDIR:-/home/<%= user %>/optinomic-build}
/bin/su - <%= user %> -c "bash /home/<%= user %>/build.sh"

cd "$BH_BASEDIR"

declare -a arr=(therapy-server/therapy-server.keter)

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


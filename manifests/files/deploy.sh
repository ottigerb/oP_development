#!/bin/bash
#
# Script to deploy new app
#
# normal run
# ./apply.sh


function unzip_keter () {
	app_name='rednucleus_app_super'
	dir_builds=/opt/BayesHive/builds
	[[ -d $dir_builds ]] || mkdir -p $dir_builds
	cd $dir_builds
	new=$(date +%F)-$(ls -1d $(date +%F)*|wc -l)
	mkdir $new
	cd $new
	tar -xzf /opt/BayesHive/incoming/BayesHive.keter
        chown -R <%= user %> .
        cd $dir_builds
	supervisorctl stop $app_name
	ln -sfn $new  current
        chown -R <%= user %> current
	supervisorctl start $app_name
}


unzip_keter
 
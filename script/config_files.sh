#!/usr/bin/env bash

# TODO: script configuration of these files
# TODO: run as application user or chown the results to them

USER="vagrant"
USERHOME="/home/$USER"

APPLICATION_LOCATION=~/Source/archives-demo/project-code/newsletter-demo
APPLICATION_USER="sufia"

if [ ! -f $USERHOME/.provisioning-progress ]; then
  touch $USERHOME/.provisioning-progress
  echo "--> Progress file created in $USERHOME/.provision-progress"
else
  echo "--> Progress file exists in $USERHOME/.provisioning-progress"
fi

if grep -q +config_files $USERHOME/.provisioning-progress; then
  echo "--> config_files already created, moving on."
else
  echo "--> creating config_files"
	pushd $APPLICATION_LOCATION/config
		cp analytics.yml.template analytics.yml
		cp blacklight.yml.template blacklight.yml
		cp database.yml.template database.yml
		cp fedora.yml.template fedora.yml
		cp jetty.yml.template jetty.yml
		cp redis.yml.template redis.yml
		cp secrets.yml.template secrets.yml
		cp solr.yml.template solr.yml
		cp environments/development.rb.template environments/development.rb
		cp environments/production.rb.template environments/production.rb
		sudo chown -R $APPLICATION_USER: $APPLICATION_LOCATION/config
	popd
	echo +config_files >> $USERHOME/.provisioning-progress
	echo "--> config_files created"
fi

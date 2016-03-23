#!/usr/bin/env bash

USER="vagrant"
USERHOME="/home/$USER"

APPLICATION_NAME="newsletter-demo"
APPLICATION_USER="sufia"

if [ ! -f $USERHOME/.provisioning-progress ]; then
  touch $USERHOME/.provisioning-progress
  echo "--> Progress file created in $USERHOME/.provision-progress"
else
  echo "--> Progress file exists in $USERHOME/.provisioning-progress"
fi

# NOTE: while this works; in the end, it's owned by vagrant.
# and it warns, "Don't run Bundler as root."
if grep -q +application $USERHOME/.provisioning-progress; then
  echo "--> application already created, moving on."
else
  echo "--> creating $APPLICATION_NAME"
	sudo mkdir -p /opt/$APPLICATION_NAME
	cd /opt/
	rails new $APPLICATION_NAME -d postgresql --skip-bundle
	cd $APPLICATION_NAME
	bundle install --path vendor/bundle
	sudo chown $APPLICATION_USER: /opt/$APPLICATION_NAME
  echo +application >> $USERHOME/.provisioning-progress
	echo "--> $APPLICATION_NAME created"
fi

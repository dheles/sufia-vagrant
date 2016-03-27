#!/usr/bin/env bash

USER="vagrant"
USERHOME="/home/$USER"

APPLICATION_NAME="newsletter-demo"
APPLICATION_USER="sufia"
APPLICATION_LOCATION="$USERHOME/$APPLICATION_NAME"

if [ ! -f $USERHOME/.provisioning-progress ]; then
  touch $USERHOME/.provisioning-progress
  echo "--> Progress file created in $USERHOME/.provision-progress"
else
  echo "--> Progress file exists in $USERHOME/.provisioning-progress"
fi

# NOTE: while this works; in the end, it's owned by vagrant.
# ...like really, really owned by vagrant. apparently, you can't chown shared folders.
# ...or more accurately, you can chown all you want, in the end, vagrant just disregards it
if grep -q +application $USERHOME/.provisioning-progress; then
  echo "--> application already created, moving on."
else
  echo "--> creating $APPLICATION_NAME"
	sudo mkdir -p $APPLICATION_LOCATION
  sudo chown $APPLICATION_USER: $APPLICATION_LOCATION
	#cd $USERHOME/
	sudo su - $APPLICATION_USER bash -c "cd $APPLICATION_LOCATION && rails new $APPLICATION_NAME -d postgresql --skip-bundle"
	#cd $APPLICATION_NAME
  # TODO: "Don't run Bundler as root."
	sudo su - $APPLICATION_USER bash -c "cd $APPLICATION_LOCATION && bundle install --path vendor/bundle"
  #doesn't work anyway and causes problems for NFS synced folders in VirtualBox:
	#sudo chown $APPLICATION_USER: $USERHOME/$APPLICATION_NAME
  echo +application >> $USERHOME/.provisioning-progress
	echo "--> $APPLICATION_NAME created"
fi

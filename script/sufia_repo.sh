#!/usr/bin/env bash

USER="vagrant"
USERHOME="/home/$USER"

APPLICATION_NAME="newsletter-demo"
APPLICATION_LOCATION="/opt/$APPLICATION_NAME"
APPLICATION_USER="sufia"
REPO="https://github.com/dheles/archives-demo.git"
BRANCH="--branch active-fedora_lessthan_9.8"

if [ ! -f $USERHOME/.provisioning-progress ]; then
  touch $USERHOME/.provisioning-progress
  echo "--> Progress file created in $USERHOME/.provision-progress"
else
  echo "--> Progress file exists in $USERHOME/.provisioning-progress"
fi

if grep -q +$APPLICATION_NAME $USERHOME/.provisioning-progress; then
  echo "--> $APPLICATION_NAME already created, moving on."
else
  echo "--> creating $APPLICATION_NAME"
  if [ ! -d "$APPLICATION_LOCATION" ]; then
    sudo mkdir -p $APPLICATION_LOCATION
  else
    sudo rm -rf $APPLICATION_LOCATION
  fi
	git clone $REPO $BRANCH $APPLICATION_LOCATION
	sudo chown -R $APPLICATION_USER: $APPLICATION_LOCATION
	# TODO: assumes a production deployment. parameterize.
	sudo su - $APPLICATION_USER bash -c "cd $APPLICATION_LOCATION && bundle install --deployment --without development"
  echo +$APPLICATION_NAME >> $USERHOME/.provisioning-progress
	echo "--> $APPLICATION_NAME created"
fi

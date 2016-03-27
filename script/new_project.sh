#!/usr/bin/env bash

# creates a rails app owned by the specified application user

USER="vagrant"
USERHOME="/home/$USER"

APPLICATION_NAME="newsletter-demo"
APPLICATION_USER="sufia"
APPLICATION_USERHOME="/home/$APPLICATION_USER"
APPLICATION_LOCATION="$APPLICATION_USERHOME/$APPLICATION_NAME"

if [ ! -f $USERHOME/.provisioning-progress ]; then
  touch $USERHOME/.provisioning-progress
  echo "--> Progress file created in $USERHOME/.provision-progress"
else
  echo "--> Progress file exists in $USERHOME/.provisioning-progress"
fi

if grep -q +rails_app $USERHOME/.provisioning-progress; then
  echo "--> rails_app already created, moving on."
else
  echo "--> creating rails_app"
	sudo mkdir -p $APPLICATION_LOCATION
  sudo chown $APPLICATION_USER: $APPLICATION_LOCATION
	sudo su - $APPLICATION_USER bash -c "cd $APPLICATION_USERHOME && rails new $APPLICATION_NAME -d postgresql --skip-bundle"
	sudo su - $APPLICATION_USER bash -c "cd $APPLICATION_LOCATION && bundle install --path vendor/bundle"
  echo +rails_app >> $USERHOME/.provisioning-progress
	echo "--> rails_app created"
fi

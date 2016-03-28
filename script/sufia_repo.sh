#!/usr/bin/env bash

USER="vagrant"
USERHOME="/home/$USER"

APPLICATION_NAME="newsletter-demo"
APPLICATION_LOCATION="/opt/$APPLICATION_NAME"
APPLICATION_USER="sufia"
REPO="https://github.com/dheles/archives-demo.git"

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
	sudo mkdir -p /opt/$APPLICATION_NAME
	cd /opt/
	git clone $REPO $APPLICATION_NAME
	sudo chown -R $APPLICATION_USER: /opt/$APPLICATION_NAME
	cd $APPLICATION_NAME
	# TODO: assumes a production deployment. parameterize.
	# TODO: can't seem to use bundle from script
	sudo su - $APPLICATION_USER bash -c "cd $APPLICATION_LOCATION && bundle install --deployment --without development"
  echo +$APPLICATION_NAME >> $USERHOME/.provisioning-progress
	echo "--> $APPLICATION_NAME created"
fi

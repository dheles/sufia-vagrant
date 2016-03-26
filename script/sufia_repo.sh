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

if grep -q +sufia $USERHOME/.provisioning-progress; then
  echo "--> sufia already created, moving on."
else
  echo "--> creating $APPLICATION_NAME"
	sudo mkdir -p /opt/$APPLICATION_NAME
	cd /opt/
	sudo chown $APPLICATION_USER: /opt/$APPLICATION_NAME
	git clone https://github.com/jhu-sheridan-libraries/newsletter-demo.git $APPLICATION_NAME
	cd $APPLICATION_NAME
	# TODO: assumes a production deployment. parameterize.
	bundle install --without development
  echo +sufia >> $USERHOME/.provisioning-progress
	echo "--> $APPLICATION_NAME created"
fi

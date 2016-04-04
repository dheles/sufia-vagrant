#!/usr/bin/env bash

USER="vagrant"
USERHOME="/home/$USER"

APPLICATION_USER="sufia"
APPLICATION_NAME="newsletter-demo"
APPLICATION_LOCATION="/opt/$APPLICATION_NAME"
VAR_FILE="$APPLICATION_LOCATION/.rbenv-vars"

if [ ! -f $USERHOME/.provisioning-progress ]; then
  touch $USERHOME/.provisioning-progress
  echo "--> Progress file created in $USERHOME/.provision-progress"
else
  echo "--> Progress file exists in $USERHOME/.provisioning-progress"
fi

# ruby
if grep -q +env_vars $USERHOME/.provisioning-progress; then
  echo "--> Environment vars already configured, moving on."
else
  echo "--> Configuring environment vars..."

	if [ ! -f "$VAR_FILE" ]; then
		sudo su - $APPLICATION_USER bash -c "touch $VAR_FILE"
		echo "--> Environment variables file created in $VAR_FILE"
	else
		echo "--> Environment variables file exists in $VAR_FILE"
	fi

	sudo su - $APPLICATION_USER bash -c "cd $APPLICATION_LOCATION && echo 'SECRET_KEY_BASE=`bundle exec rake secret`' >> $VAR_FILE"

	echo +env_vars >> $USERHOME/.provisioning-progress
	echo "--> Environment vars now configured."
fi

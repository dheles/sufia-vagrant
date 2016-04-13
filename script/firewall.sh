#!/usr/bin/env bash

# configures firewall for a sufia instance

# set defaults:
ADMIN="vagrant"
ADMIN_HOME="/home/$ADMIN"

if [ ! -f $ADMIN_HOME/.provisioning-progress ]; then
  touch $ADMIN_HOME/.provisioning-progress
  echo "--> Progress file created in $ADMIN_HOME/.provision-progress"
else
  echo "--> Progress file exists in $ADMIN_HOME/.provisioning-progress"
fi

if grep -q +firewall $ADMIN_HOME/.provisioning-progress; then
  echo "--> firewall already configured, moving on."
else
  echo "--> configuring firewall..."

  sudo systemctl enable firewalld
  sudo systemctl start firewalld
	#firewall-cmd --get-active-zones
	sudo firewall-cmd --permanent --zone=public --add-service=http
	sudo firewall-cmd --permanent --zone=public --add-service=https
	sudo firewall-cmd --reload

  echo +firewall >> $ADMIN_HOME/.provisioning-progress
  echo "--> firewall now configured."
fi

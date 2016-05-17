#!/usr/bin/env bash

# configures firewall for a sufia instance
function usage
{
  echo "usage: firewall [[[-a ADMIN ] | [-h]]"
}

# set defaults:
ADMIN="vagrant"

# process arguments:
while [ "$1" != "" ]; do
  case $1 in
    -a | --admin )        shift
                          ADMIN=$1
                          ;;
    -h | --help )         usage
                          exit
                          ;;
    * )                   usage
                          exit 1
  esac
  shift
done

# set remaining vars
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
  # NOTE: not for actual production:
  sudo firewall-cmd --permanent --zone=public --add-port=8983/tcp
	sudo firewall-cmd --reload

  echo +firewall >> $ADMIN_HOME/.provisioning-progress
  echo "--> firewall now configured."
fi

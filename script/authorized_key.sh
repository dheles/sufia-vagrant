#!/usr/bin/env bash

# given an authorized public key present as ~/.ssh/authorized_key.pub,
# and given a preexisting application user,
# grants the key to the application user

function usage
{
  echo "usage: authorized_key [[[-a ADMIN ] [-u APPLICATION_USER]] | [-h]]"
}

# set defaults:
ADMIN="vagrant"
ADMIN_HOME="/home/$ADMIN"
APPLICATION_USER="sufia"

# process arguments:
while [ "$1" != "" ]; do
  case $1 in
    -a | --admin )    shift
                      ADMIN=$1
                      ;;
    -u | --user )    APPLICATION_USER=$1
                      ;;
    -h | --help )     usage
                      exit
                      ;;
    * )               usage
                      exit 1
  esac
  shift
done

# progress file
if [ ! -f $ADMIN_HOME/.provisioning-progress ]; then
  touch $ADMIN_HOME/.provisioning-progress
  echo "--> Progress file created in $ADMIN_HOME/.provision-progress"
else
  echo "--> Progress file exists in $ADMIN_HOME/.provisioning-progress"
fi

# TODO: review: currently adding user in a previous step
# # adduser
# if grep -q +adduser .provisioning-progress; then
#   echo "--> application user already added, moving on."
# else
#   echo "--> adding application user..."
# 	sudo adduser sufia
#   echo +adduser >> /home/vagrant/.provisioning-progress
#   echo "--> application user now added."
# fi

# authorized key
if grep -q +authorized_key $ADMIN_HOME/.provisioning-progress; then
  echo "--> authorized_key already added, moving on."
else
  echo "--> adding authorized_key..."
	sudo mkdir -p /home/$APPLICATION_USER/.ssh
	sudo touch /home/$APPLICATION_USER/.ssh/authorized_keys
	sudo sh -c "cat $ADMIN_HOME/.ssh/authorized_key.pub >> /home/$APPLICATION_USER/.ssh/authorized_keys"
	sudo chown -R $APPLICATION_USER: /home/$APPLICATION_USER/.ssh
	sudo chmod 700 /home/$APPLICATION_USER/.ssh
	sudo sh -c "chmod 600 /home/$APPLICATION_USER/.ssh/*"
  echo +authorized_key >> $ADMIN_HOME/.provisioning-progress
  echo "--> authorized_key now added."
fi

#!/usr/bin/env bash

# given an authorized public key present as ~/.ssh/authorized_key.pub,
# and given a preexisting application user,
# grants the key to the application user

# TODO: generalize for use outside of vagrant:
USER="vagrant"
USERHOME="/home/$USER"

APPLICATION_USER="sufia"

# progress file
if [ ! -f $USERHOME/.provisioning-progress ]; then
  touch $USERHOME/.provisioning-progress
  echo "--> Progress file created in $USERHOME/.provision-progress"
else
  echo "--> Progress file exists in $USERHOME/.provisioning-progress"
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
if grep -q +authorized_key $USERHOME/.provisioning-progress; then
  echo "--> authorized_key already added, moving on."
else
  echo "--> adding authorized_key..."
	sudo mkdir -p /home/$APPLICATION_USER/.ssh
	sudo touch /home/$APPLICATION_USER/.ssh/authorized_keys
	sudo sh -c "cat $USERHOME/.ssh/authorized_key.pub >> /home/$APPLICATION_USER/.ssh/authorized_keys"
	sudo chown -R $APPLICATION_USER: /home/$APPLICATION_USER/.ssh
	sudo chmod 700 /home/$APPLICATION_USER/.ssh
	sudo sh -c "chmod 600 /home/$APPLICATION_USER/.ssh/*"
  echo +authorized_key >> $USERHOME/.provisioning-progress
  echo "--> authorized_key now added."
fi

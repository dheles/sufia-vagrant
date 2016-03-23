#!/usr/bin/env bash

# given an authorized public key present as /home/vagrant/.ssh/authorized_key.pub,
# and given a preexisting application user,
# grants the key to the application user
# TODO: generalize for use outside of vagrant

APPLICATION_USER="sufia"

# progress file
if [ ! -f /home/vagrant/.provisioning-progress ]; then
  touch /home/vagrant/.provisioning-progress
  echo "--> Progress file created in /home/vagrant/.provision-progress"
else
  echo "--> Progress file exists in /home/vagrant/.provisioning-progress"
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
# TODO: this stopped working for some reason.
# error: ==> default: sh: /home/sufia/.ssh/authorized_keys: No such file or directory
# ==> default: chmod: cannot access ‘/home/sufia/.ssh/*’: No such file or directory
if grep -q +authorized_key .provisioning-progress; then
  echo "--> authorized_key already added, moving on."
else
  echo "--> adding authorized_key..."
	sudo mkdir -p ~$APPLICATION_USER/.ssh
	sudo touch ~$APPLICATION_USER/.ssh/authorized_keys
	sudo sh -c "cat /home/vagrant/.ssh/authorized_key.pub >> ~$APPLICATION_USER/.ssh/authorized_keys"
	sudo chown -R $APPLICATION_USER: ~$APPLICATION_USER/.ssh
	sudo chmod 700 ~$APPLICATION_USER/.ssh
	sudo sh -c "chmod 600 ~$APPLICATION_USER/.ssh/*"
  echo +authorized_key >> /home/vagrant/.provisioning-progress
  echo "--> authorized_key now added."
fi

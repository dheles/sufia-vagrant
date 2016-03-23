#!/usr/bin/env bash

APPLICATION_NAME="newsletter-demo"
APPLICATION_USER="sufia"

if [ ! -f /home/vagrant/.provisioning-progress ]; then
  touch /home/vagrant/.provisioning-progress
  echo "--> Progress file created in /home/vagrant/.provision-progress"
else
  echo "--> Progress file exists in /home/vagrant/.provisioning-progress"
fi

# NOTE: while this works; in the end, it's owned by vagrant.
# and it warns, "Don't run Bundler as root."
if grep -q +application .provisioning-progress; then
  echo "--> application already created, moving on."
else
  echo "--> creating $APPLICATION_NAME"
	sudo mkdir -p /opt/$APPLICATION_NAME
	sudo chown sufia: /opt/$APPLICATION_NAME
	sudo su - $APPLICATION_USER
	cd /opt/
	rails new $APPLICATION_NAME -d postgresql --skip-bundle
	cd $APPLICATION_NAME
	bundle install --path vendor/bundle
  echo +application >> /home/vagrant/.provisioning-progress
	echo "--> $APPLICATION_NAME created"
fi

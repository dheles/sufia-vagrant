#!/usr/bin/env bash

# creates a rails app owned by the specified application user
function usage
{
  echo "usage: new_project [[[-a ADMIN ] [-u APPLICATION_USER]] [-n APPLICATION_NAME]] | [-h]]"
}

# set defaults:
ADMIN="vagrant"
ADMIN_HOME="/home/$ADMIN"

APPLICATION_USER="sufia"
APPLICATION_USER_HOME="/home/$APPLICATION_USER"
APPLICATION_NAME="newsletter-demo"
APPLICATION_BUILD_LOCATION="$APPLICATION_USER_HOME/$APPLICATION_NAME"

# process arguments:
while [ "$1" != "" ]; do
  case $1 in
    -a | --admin )    shift
                      ADMIN=$1
                      ;;
    -u | --user )     shift
                      APPLICATION_USER=$1
                      ;;
    -n | --name )     shift
                      APPLICATION_NAME=$1
                      ;;
    -h | --help )     usage
                      exit
                      ;;
    * )               usage
                      exit 1
  esac
  shift
done

if [ ! -f $ADMIN_HOME/.provisioning-progress ]; then
  touch $ADMIN_HOME/.provisioning-progress
  echo "--> Progress file created in $ADMIN_HOME/.provision-progress"
else
  echo "--> Progress file exists in $ADMIN_HOME/.provisioning-progress"
fi

if grep -q +rails_app $ADMIN_HOME/.provisioning-progress; then
  echo "--> rails_app already created, moving on."
else
  echo "--> creating rails_app"
	sudo mkdir -p $APPLICATION_BUILD_LOCATION
  sudo chown $APPLICATION_USER: $APPLICATION_BUILD_LOCATION
	sudo su - $APPLICATION_USER bash -c "cd $APPLICATION_USER_HOME && rails new $APPLICATION_NAME -d postgresql --skip-bundle"
	sudo su - $APPLICATION_USER bash -c "cd $APPLICATION_BUILD_LOCATION && bundle install --path vendor/bundle"
  echo +rails_app >> $ADMIN_HOME/.provisioning-progress
	echo "--> rails_app created"
fi

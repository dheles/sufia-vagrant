#!/usr/bin/env bash

# installs a customized sufia instance from a repo
function usage
{
  echo "usage: sufia_repo [[[-a ADMIN ] [-u APPLICATION_USER]] [-n APPLICATION_NAME]] [-b BRANCH]] [-e RAILS_ENVIRONMENT]] | [-h]]"
}

# set defaults:
ADMIN="vagrant"
APPLICATION_USER="sufia"
APPLICATION_NAME="sufia-demo"
# if specifying a branch, use something like "--branch BRANCH_NAME"
BRANCH=""
RAILS_ENVIRONMENT="development"

# process arguments:
while [ "$1" != "" ]; do
  case $1 in
    -a | --admin )        shift
                          ADMIN=$1
                          ;;
    -u | --user )         shift
                          APPLICATION_USER=$1
                          ;;
    -n | --name )         shift
                          APPLICATION_NAME=$1
                          ;;
    -b | --branch )       shift
                          BRANCH="-b $1"
                          ;;
    -e | --environment )  shift
                          RAILS_ENVIRONMENT=$1
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
APPLICATION_INSTALL_LOCATION="/opt/$APPLICATION_NAME"
REPO="https://github.com/jhu-sheridan-libraries/sufia-demo.git"

if [ ! -f $ADMIN_HOME/.provisioning-progress ]; then
  touch $ADMIN_HOME/.provisioning-progress
  echo "--> Progress file created in $ADMIN_HOME/.provision-progress"
else
  echo "--> Progress file exists in $ADMIN_HOME/.provisioning-progress"
fi

if grep -q +$APPLICATION_NAME $ADMIN_HOME/.provisioning-progress; then
  echo "--> $APPLICATION_NAME already created, moving on."
else
  echo "--> creating $APPLICATION_NAME"
  if [ ! -d "$APPLICATION_INSTALL_LOCATION" ]; then
    sudo mkdir -p $APPLICATION_INSTALL_LOCATION
  else
    sudo rm -rf $APPLICATION_INSTALL_LOCATION
  fi
  echo "cloning: $REPO $BRANCH $APPLICATION_INSTALL_LOCATION"
	git clone $REPO $BRANCH $APPLICATION_INSTALL_LOCATION
	sudo chown -R $APPLICATION_USER: $APPLICATION_INSTALL_LOCATION

	# set install arguments appropriate for the environment
  INSTALL_ARGS=""
  if [ $RAILS_ENVIRONMENT = "production" ]; then
    INSTALL_ARGS="--deployment --without development"
  else
    INSTALL_ARGS="--path vendor/bundle"
  fi

  sudo su - $APPLICATION_USER bash -c "cd $APPLICATION_INSTALL_LOCATION && bundle install $INSTALL_ARGS"
  echo +$APPLICATION_NAME >> $ADMIN_HOME/.provisioning-progress
	echo "--> $APPLICATION_NAME created"
fi

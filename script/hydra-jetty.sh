#!/usr/bin/env bash

# installs and configures hydra jetty for a sufia instance
function usage
{
  echo "usage: hydra-jetty [[[-a ADMIN ] [-u APPLICATION_USER]] [-n APPLICATION_NAME]] | [-h]]"
}

# set defaults:
ADMIN="vagrant"
APPLICATION_USER="sufia"
APPLICATION_NAME="sufia-demo"

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

# set remaining vars
ADMIN_HOME="/home/$ADMIN"
APPLICATION_INSTALL_LOCATION="/opt/$APPLICATION_NAME"

if [ ! -f $ADMIN_HOME/.provisioning-progress ]; then
  touch $ADMIN_HOME/.provisioning-progress
  echo "--> Progress file created in $ADMIN_HOME/.provision-progress"
else
  echo "--> Progress file exists in $ADMIN_HOME/.provisioning-progress"
fi

if grep -q +hydra-jetty $ADMIN_HOME/.provisioning-progress; then
  echo "--> hydra-jetty already configured, moving on."
else
  echo "--> configuring hydra-jetty"
	# NOTE: since hydra-jetty does not provide a production core, the pid still indicates "development", regardless of the environment
	sudo su - $APPLICATION_USER bash -c "kill -INT $(cat $APPLICATION_INSTALL_LOCATION/tmp/pids/_opt_sufia-demo_jetty_development.pid)"

	sudo su - $APPLICATION_USER bash -c "cd $APPLICATION_INSTALL_LOCATION && bundle exec rake jetty:stop"
	sudo su - $APPLICATION_USER bash -c "cd $APPLICATION_INSTALL_LOCATION && bundle exec rake jetty:clean"
	sudo su - $APPLICATION_USER bash -c "cd $APPLICATION_INSTALL_LOCATION && bundle exec rake sufia:jetty:config"
	sudo su - $APPLICATION_USER bash -c "cd $APPLICATION_INSTALL_LOCATION && bundle exec rake jetty:start"
	echo +hydra-jetty >> $ADMIN_HOME/.provisioning-progress
	echo "--> hydra-jetty configured"
fi

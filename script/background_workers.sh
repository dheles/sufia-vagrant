#!/usr/bin/env bash

# starts background workers for a sufia instance
# TODO: add an init script for autorestarting
function usage
{
  echo "usage: background_workers [[[-a ADMIN ] [-u APPLICATION_USER]] [-n APPLICATION_NAME]] [-e RAILS_ENVIRONMENT]] | [-h]]"
}

# set defaults:
ADMIN="vagrant"
ADMIN_HOME="/home/$ADMIN"

APPLICATION_USER="sufia"
APPLICATION_NAME="newsletter-demo"
APPLICATION_INSTALL_LOCATION="/opt/$APPLICATION_NAME"
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

# database setup
if [ ! -f $ADMIN_HOME/.provisioning-progress ]; then
  touch $ADMIN_HOME/.provisioning-progress
  echo "--> Progress file created in $ADMIN_HOME/.provision-progress"
else
  echo "--> Progress file exists in $ADMIN_HOME/.provisioning-progress"
fi

if grep -q +background_workers $ADMIN_HOME/.provisioning-progress; then
  echo "--> background_workers already configured, moving on."
else
  echo "--> Configuring background_workers..."

  file_relative="script/restart_resque.sh"
  file="$APPLICATION_INSTALL_LOCATION/$file_relative"
  if [ ! -f "$file" ]; then
    echo "--> $file not found. creating minimal background workers script"
    sudo mkdir $APPLICATION_INSTALL_LOCATION/script
    echo "RUN_AT_EXIT_HOOKS=true TERM_CHILD=1 bundle exec resque-pool --daemon --environment $RAILS_ENVIRONMENT start" | sudo tee $file
    sudo chown $APPLICATION_USER: $file
  fi
  sudo chmod +x $file
  sudo su - $APPLICATION_USER bash -c "cd $APPLICATION_INSTALL_LOCATION && ./$file_relative $RAILS_ENVIRONMENT"


  echo +background_workers >> $ADMIN_HOME/.provisioning-progress
  echo "--> background_workers now configured."
fi

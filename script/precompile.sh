#!/usr/bin/env bash

# precompiles assets for a sufia instance
function usage
{
  echo "usage: precompile [[[-a ADMIN ] [-u APPLICATION_USER]] [-n APPLICATION_NAME] [-e RAILS_ENVIRONMENT] | [-h]]"
}

# set defaults
ADMIN="vagrant"
ADMIN_HOME="/home/$ADMIN"

APPLICATION_USER="sufia"
APPLICATION_NAME="sufia-demo"
APPLICATION_INSTALL_LOCATION="/opt/$APPLICATION_NAME"
RAILS_ENVIRONMENT="development"

# process arguments:
while [ "$1" != "" ]; do
  case $1 in
    -a | --admin )    		shift
                      		ADMIN=$1
                      		;;
    -u | --user )     		shift
                          APPLICATION_USER=$1
                      		;;
    -n | --name )     		shift
                          APPLICATION_NAME=$1
                      		;;
		-e | --environment )  shift
                          RAILS_ENVIRONMENT=$1
													;;
    -h | --help )     		usage
                      		exit
                      		;;
    * )               		usage
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

if grep -q +precompile $ADMIN_HOME/.provisioning-progress; then
  echo "--> assets already precompiled, moving on."
else
  echo "--> precompiling assets"

	sudo su - $APPLICATION_USER bash -c "cd $APPLICATION_INSTALL_LOCATION && bundle exec rake --silent assets:precompile RAILS_ENV=$RAILS_ENVIRONMENT"
	sudo systemctl restart httpd

	echo +precompile >> $ADMIN_HOME/.provisioning-progress
	echo "--> assets precompiled"
fi

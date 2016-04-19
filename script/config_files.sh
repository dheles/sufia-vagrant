#!/usr/bin/env bash

# TODO: script configuration of these files
function usage
{
  echo "usage: config_files [[[-a ADMIN ] [-u APPLICATION_USER]] [-n APPLICATION_NAME]] | [-h]]"
}

# set defaults:
ADMIN="vagrant"
ADMIN_HOME="/home/$ADMIN"

APPLICATION_USER="sufia"
APPLICATION_NAME="newsletter-demo"
APPLICATION_INSTALL_LOCATION="/opt/$APPLICATION_NAME"

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

if grep -q +config_files $ADMIN_HOME/.provisioning-progress; then
  echo "--> config_files already created, moving on."
else
  echo "--> creating config_files"
	pushd $APPLICATION_INSTALL_LOCATION/config
		cp analytics.yml.template analytics.yml
		cp blacklight.yml.template blacklight.yml
		cp database.yml.template database.yml
		cp fedora.yml.template fedora.yml
		cp jetty.yml.template jetty.yml
		cp redis.yml.template redis.yml
		cp secrets.yml.template secrets.yml
		cp solr.yml.template solr.yml
		#cp environments/development.rb.template environments/development.rb
		#cp environments/production.rb.template environments/production.rb
		sudo chown -R $APPLICATION_USER: $APPLICATION_INSTALL_LOCATION/config
	popd
	echo +config_files >> $ADMIN_HOME/.provisioning-progress
	echo "--> config_files created"
fi

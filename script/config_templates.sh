#!/usr/bin/env bash

# generates template files from the config files
# during deployment, this process can be reversed with the config_files.sh script
# TODO: finish for provisioning
function usage
{
  echo "usage: config_templates [[[-a ADMIN ] [-u APPLICATION_USER]] [-n APPLICATION_NAME]] | [-h]]"
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

if grep -q +config_templates $ADMIN_HOME/.provisioning-progress; then
  echo "--> config_templates already created, moving on."
else
  echo "--> creating config_templates"
	pushd $APPLICATION_BUILD_LOCATION/config
		cp analytics.yml analytics.yml.template
		cp blacklight.yml blacklight.yml.template
		cp database.yml database.yml.template
		cp fedora.yml fedora.yml.template
		# jetty.yml not auto-generated
		cp jetty.yml jetty.yml.template
		cp redis.yml redis.yml.template
		cp secrets.yml secrets.yml.template
		cp solr.yml solr.yml.template
		cp environments/development.rb environments/development.rb.template
		cp environments/production.rb environments/production.rb.template
		sudo chown -R $APPLICATION_USER: $APPLICATION_BUILD_LOCATION/config
	popd
	echo +config_templates >> $ADMIN_HOME/.provisioning-progress
	echo "--> config_templates created"
fi

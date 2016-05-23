#!/usr/bin/env bash

# TODO: consider using .template files instead

# configures email for a sufia instance
function usage
{
  echo "usage: mail_config [[[-a ADMIN ] [-u APPLICATION_USER]] [-n APPLICATION_NAME]] [-m DEFAULT_EMAIL]] [-s SMTP_ADDRESS]] | [-h]]"
}

# set defaults:
ADMIN="vagrant"
APPLICATION_USER="sufia"
APPLICATION_NAME="sufia-demo"
DEFAULT_EMAIL="CHANGEME@CHANGEME.EDU"
SMTP_ADDRESS="SMTP.CHANGEME.EDU"

# process arguments:
while [ "$1" != "" ]; do
  case $1 in
    -a | --admin )    shift
                      ADMIN=$1
                      ;;
    -n | --name )     shift
                      APPLICATION_NAME=$1
                      ;;
    -m | --email )    shift
                      DEFAULT_EMAIL=$1
                      ;;
    -s | --smtp )    	shift
                      SMTP_ADDRESS=$1
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
DEFAULT_EMAIL_CONFIG1="$APPLICATION_INSTALL_LOCATION/config/initializers/mailboxer.rb"
DEFAULT_EMAIL_CONFIG2="$APPLICATION_INSTALL_LOCATION/config/initializers/devise.rb"
VAR_FILE="$APPLICATION_INSTALL_LOCATION/config/application.yml"

if [ ! -f $ADMIN_HOME/.provisioning-progress ]; then
  touch $ADMIN_HOME/.provisioning-progress
  echo "--> Progress file created in $ADMIN_HOME/.provision-progress"
else
  echo "--> Progress file exists in $ADMIN_HOME/.provisioning-progress"
fi

if grep -q +mail_config $ADMIN_HOME/.provisioning-progress; then
  echo "--> email already configured, moving on."
else
  echo "--> configuring email"

	sed -i s/"no-reply@mailboxer.com"/$DEFAULT_EMAIL/ $DEFAULT_EMAIL_CONFIG1
	sed -i "s/config.mailer_sender.*/config.mailer_sender = '$DEFAULT_EMAIL'/" $DEFAULT_EMAIL_CONFIG2

	if [ ! -f "$VAR_FILE" ]; then
		sudo su - $APPLICATION_USER bash -c "touch $VAR_FILE"
		echo "--> Environment variables file created in $VAR_FILE"
	else
		echo "--> Environment variables file exists in $VAR_FILE"
	fi

	sudo su - $APPLICATION_USER bash -c "echo SMTP_ADDRESS: $SMTP_ADDRESS >> $VAR_FILE"

	echo +mail_config >> $ADMIN_HOME/.provisioning-progress
	echo "--> email configured"
fi
